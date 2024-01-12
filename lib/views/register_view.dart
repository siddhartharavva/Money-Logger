
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer'as devtools show log;

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
                  final userCredential = await  FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                    );
                        Navigator.of(context).pushNamedAndRemoveUntil(
                  '/verify',
                  (route) => false,
                );
                  devtools.log(userCredential.toString());
                }on FirebaseAuthException catch(e){
                  if(e.code == "weak-password"){
                   devtools.log("Password should be atleast 6 characters");
                }
                else if(e.code == "email-already-in-use"){
                   devtools.log("The email address is already in use");
                }
                else if(e.code == 'invalid-email'){
                   devtools.log("Invalid email entered");
                  }
                 }
                },
          
                  child: const Text("Register",
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), 
                ),
              ),
              TextButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
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
