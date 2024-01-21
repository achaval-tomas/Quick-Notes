import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: Column(
        children: [
      
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
            hintText: 'myemail@example.com'
            ),
          ),
      
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
            hintText: 'Enter your password'
            ),
          ),
      
          TextButton(
            onPressed:() async {
      
              final email = _email.text;
              final password = _password.text;
      
              try {
                
                await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                  email: email,
                  password: password
                );

                if (!context.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (_) => false,
                );

              } on FirebaseAuthException catch (e) {

                if (!context.mounted) return;
                if (e.code == 'invalid-credential'){
                  await showErrorDialog(
                    context,
                    'Incorrect email or password.'
                  );
                } else {
                  await showErrorDialog(
                    context,
                    'Error: ${e.code}',
                  );
                }

              } catch (e) {

                await showErrorDialog(
                  context,
                  'Error: $e',
                );

              }

            }, 
            child: const Text('Log In')
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (_) => false
                );
            }, 
            child: const Text("Don't have an account? Register here!"),
          )
        ],
      ),
    );
  }
}