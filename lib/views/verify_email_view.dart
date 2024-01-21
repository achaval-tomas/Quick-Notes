import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [

          const Text("We've sent you an email verification. Please check your inbox to verify your account."),

          const Text("If you haven't received an email, press the button below."),

          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Send email verification'),
          ),

          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();

              if (!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (_) => false
              );

            },
            child: const Text('Go Back'),
          )

        ],
      ),
    );
  }
}