import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart'
    show join;

class NotesService {
  
  Database? _db;

  Database _getDatabaseOrThrow(){
    final db = _db;
    if (db == null) {
      throw DataBaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> open() async {
    if (_db != null) throw DataBaseAlreadyOpenException();

    try {

      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      // Creating user and note tables.
      await db.execute(createUserTable);
      await db.execute(createNoteTable);

      await _cacheNotes();

    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }

  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DataBaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()]
    );
    if (results.isNotEmpty) throw UserAlreadyExists();

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(
      email: email,
      id: userId
    );

  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()]
    );
    if (deletedCount != 1) throw CouldNotDeleteUser();
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()]
    );
    if (results.isEmpty) throw CouldNotFindUser();

    return DatabaseUser.fromRow(results.first);
  }

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    // Make sure owner exists in the database.
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) throw CouldNotFindUser();

    // Create the note.
    const text = '';
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });

    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true
    );

    _notes.add(note);
    _notesStreamController.add(_notes);

    return note;
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) throw CouldNotDeleteNote();

    _notes.removeWhere((note) => note.id == id);
    _notesStreamController.add(_notes);

  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(noteTable);

    _notes = [];
    _notesStreamController.add(_notes);

    return numberOfDeletions;
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) throw CouldNotFindNote();

    final note = DatabaseNote.fromRow(notes.first);

    _notes.removeWhere((note) => note.id == id);
    _notes.add(note);
    _notesStreamController.add(_notes);

    return note;  
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);

    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text
  }) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);

    final updatesCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });
    if (updatesCount == 0) throw CouldNotUpdateNote();

    final updatedNote = await getNote(id: note.id);
    
    _notes.removeWhere((note) => note.id == updatedNote.id);
    _notes.add(updatedNote);
    _notesStreamController.add(_notes);

    return updatedNote;
  }

  // Caching a local list of fetched notes.
  List<DatabaseNote> _notes = [];
  final _notesStreamController = 
      StreamController<List<DatabaseNote>>.broadcast();

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

}


@immutable
class DatabaseUser {
  final int id;
  final String email;
  DatabaseUser({
    required this.id,
    required this.email
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
    : id = map[idColumn] as int,
      userId = map[userIdColumn] as int,
      text = map[textColumn] as String,
      isSyncedWithCloud = 
          (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID = $id, userID = $userId, isSyncedWithCloud: $isSyncedWithCloud';

  @override
  bool operator==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

}

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
  "id"	INTEGER NOT NULL,
  "email"	TEXT NOT NULL UNIQUE,
  PRIMARY KEY("id" AUTOINCREMENT)
);''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
  "id"	INTEGER NOT NULL,
  "user_id"	INTEGER NOT NULL,
  "text"	TEXT,
  "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY("id" AUTOINCREMENT),
  FOREIGN KEY("user_id") REFERENCES "user"("id")
);''';