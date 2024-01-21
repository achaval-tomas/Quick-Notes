import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

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
                  '/notes/',
                  (_) => false,
                );

              } on FirebaseAuthException catch (e) {

                if (e.code == 'invalid-credential'){
                  devtools.log('Incorrect email or password.');
                }
                
              }
      
            }, 
      
            child: const Text('Log In')
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/register/',
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