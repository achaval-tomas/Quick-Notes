import 'package:flutter/material.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool?> showSortByDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: context.loc.sort_by_title,
    content: '',
    optionsBuilder: () => {
      context.loc.sort_by_last_access: true,
      context.loc.sort_by_creation: false
    },
  );
}