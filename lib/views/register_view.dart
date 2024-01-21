import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

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
    return Scaffold(

      appBar: AppBar(
        title: const Text('Register'),
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
                  .createUserWithEmailAndPassword(
                  email: email,
                  password: password
                );

                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();

                if (!context.mounted) return;
                Navigator.of(context).pushNamed(
                  verifyEmailRoute,
                );

              } on FirebaseAuthException catch (e) {
                
                if (!context.mounted) return;
                if (e.code == 'email-already-in-use') {
                  await showErrorDialog(
                    context,
                    'This email is already in use.'
                  );
                } else if (e.code == 'weak-password'){
                  await showErrorDialog(
                    context,
                    'Password is too weak.'
                  );
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(
                    context,
                    'Invalid email format.'
                  );
                } else {
                  await showErrorDialog(
                  context,
                  'Error: ${e.code}',
                  );
                }
      
              } catch (e){ 

                await showErrorDialog(
                  context,
                  'Error: $e',
                );

              }

            }, 
      
            child: const Text('Register')
          ),

          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (_) => false
                );
            }, 
            child: const Text('Already have an account? Log In!'),
          )
        ],
      ),
    );
  }
}