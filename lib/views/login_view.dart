import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is WrongCredentialAuthException) {
            await showErrorDialog(context, context.loc.login_error_wrong_credentials);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, context.loc.login_error_auth_error);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.title),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    context.loc.login_view_prompt,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        InputDecoration(hintText: context.loc.email_text_field_placeholder),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration:
                        InputDecoration(hintText: context.loc.password_text_field_placeholder),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text.trim();
                      final password = _password.text;
                      context.read<AuthBloc>()
                            .add(AuthEventLogIn(email, password));
                    },
                    child: Text(context.loc.login)
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>()
                              .add(const AuthEventForgotPassword());
                    },
                    child: Text(context.loc.login_view_forgot_password),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>()
                              .add(const AuthEventShouldRegister());
                    },
                    child: Text(context.loc.login_view_not_registered_yet),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
