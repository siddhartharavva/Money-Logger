
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer'as devtools show log;

import 'package:money_logger/constants/routes.dart';
import 'package:money_logger/utilities/Show_Error_dialog.dart';

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
    return  Scaffold(backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(backgroundColor: Colors.black,
        title: const Text("Register",
        style: TextStyle(color: Colors.white)
         ),
        ),
      body: Column(
            children: [
              TextField(
                controller: _email,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Enter your email here",
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
          
                decoration: const InputDecoration(
                  hintText: "Enter the password here",
                  
          
                ),
              ),
              TextButton(
            
                style: TextButton.styleFrom(
                 backgroundColor: const Color.fromARGB(255, 79, 79, 79),
                 
                  ),
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                try{
                   await  FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                    );
                    final user = FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();
                        Navigator.of(context).pushNamed(VerifyEmailRoute);
                }on FirebaseAuthException catch(e){
                  if(e.code == "weak-password"){
                   await showErrorDialog(context,
                    "enter a stronger password",
                    );
                }
                else if(e.code == "email-already-in-use"){
                  await showErrorDialog(context,
                   "Email already in use",
                   );                
                }
                else if(e.code == 'invalid-email'){
                  await showErrorDialog(context,
                   "Invalid email entered",
                  );                  
                  }
                 }catch(e){
                  await showErrorDialog(context,
                   e.toString(),
                   );
                 }
                 
                },
          
                  child: const Text("Register",
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), 
                ),
              ),
              TextButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginRoute,
                (route) => false,
              );
              }, child: const Text("Already registered?.. login here",
                 style: TextStyle(color: Colors.black), 
                ),
              ),
            ],
          ),
    );
  }
  }
