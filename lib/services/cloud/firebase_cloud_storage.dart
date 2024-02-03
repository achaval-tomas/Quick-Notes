import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/constants/regex.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  FirebaseCloudStorage._sharedInstance();
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  String _updateNoteTime(String note){
    final time = getDate(null);
    final text = getContent(note);
    return time + text;
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final text = _updateNoteTime('');
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: text,
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: text
    );
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)
          ),
        );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
    notes.where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc)));

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: _updateNoteTime(text)});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> deleteAllNotes({required String ownerUserId}) async {
    try {
      final allnotes = await getNotes(ownerUserId: ownerUserId);
      for (var n in allnotes){
        deleteNote(documentId: n.documentId);
      }
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

}