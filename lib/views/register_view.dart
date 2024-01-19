import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  
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
    return Column(
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
              
              final userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                email: email,
                password: password
              );

            } on FirebaseAuthException catch (e) {

              if (e.code == 'email-already-in-use') {
                print('User already exists.');
              } else if (e.code == 'weak-password'){
                print('Password too weak.');
              } else if (e.code == 'invalid-email') {
                print('Not a valid email.');
              }

            }
          }, 

          child: const Text('Register')
        ),
      ],
    );
  }
}