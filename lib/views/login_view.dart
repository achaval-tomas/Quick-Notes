import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            await showErrorDialog(context, 'Wrong email or password.');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication Error.');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Log In'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Please log in to your account in order to interact with and create notes!',
                textAlign: TextAlign.center,
              ),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: 'myemail@example.com'),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:
                    const InputDecoration(hintText: 'Enter your password'),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>()
                        .add(AuthEventLogIn(email, password));
                },
                child: const Text('Log In')
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>()
                          .add(const AuthEventForgotPassword());
                },
                child: const Text("I forgot my password"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>()
                          .add(const AuthEventShouldRegister());
                },
                child: const Text("Don't have an account? Register here!"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
