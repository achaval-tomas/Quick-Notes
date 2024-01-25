import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

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
        title: Text(context.loc.verify_email),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
          
              Text(
                context.loc.verify_email_view_prompt,
                textAlign: TextAlign.center,
              ),
          
              Text(
                context.loc.verify_email_view_prompt2,
                textAlign: TextAlign.center,
              ),
          
              TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                    const AuthEventSendEmailVerification()
                  );
                },
                child: Text(context.loc.verify_email_send_email_verification),
              ),
          
              TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                    const AuthEventLogOut()
                  );
                },
                child: Text(context.loc.restart),
              )
          
            ],
          ),
        ),
      ),
    );
  }
}