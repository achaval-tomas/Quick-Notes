import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(
  BuildContext context,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content: "We've sent you a password reset link. Please check your inbox.",
    optionsBuilder: () => {'OK': null},
  );
}