import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteAllNotesDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Deleting All Your Notes',
    content: 'Are you sure you want to delete your notes? There is no going back.',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true
    },
  ).then((value) => value ?? false);
}