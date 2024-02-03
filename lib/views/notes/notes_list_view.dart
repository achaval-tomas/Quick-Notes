import 'package:flutter/material.dart';
import 'package:mynotes/constants/regex.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final List<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap
  });

  void sortNotes(List<CloudNote> notes){
    notes.sort(
      (a, b){
        return -getDate(a.text).compareTo(getDate(b.text));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    sortNotes(notes);
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                onTap: () {
                  onTap(note);
                },
                title: Text(
                  getContent(note.text),
                  maxLines: 1,
                  softWrap: true,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis
                ),
                subtitle: Text(
                  getDate(note.text),
                  maxLines: 1,
                  softWrap: true,
                  style: TextStyle(color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis
                ),
                tileColor: Colors.grey.shade900,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                trailing: IconButton(
                  onPressed: () async {
                    final shouldDelete = await showDeleteDialog(context);
                    if (shouldDelete) {
                      onDeleteNote(note);
                    }
                  },
                  icon: const Icon(Icons.delete)
                ),
              ),
        );
      },
    );
  }
}