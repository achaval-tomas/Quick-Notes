import 'package:flutter/material.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteAllNotesDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: context.loc.delete_all_title,
    content: context.loc.delete_all_prompt,
    optionsBuilder: () => {
      context.loc.cancel: false,
      context.loc.yes: true
    },
  ).then((value) => value ?? false);
}