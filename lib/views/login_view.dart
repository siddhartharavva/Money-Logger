import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer'as devtools show log;

import 'package:money_logger/constants/routes.dart';



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
    return  Scaffold(backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(backgroundColor: Colors.black,
        title: const Text("Login",
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
                 backgroundColor:const Color.fromARGB(255, 0, 0, 0),
                 
                  ),
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                 try{
                  final userCredential = await  FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                    );
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Ui',
                        (route) => false,
                      );
                    
                    devtools.log(userCredential.toString());
                }on FirebaseAuthException catch(e){ 
                  if(e.code =="invalid-credential"){
                    devtools.log("invalid credentials");                  }
                }
                  
                },
                  child: const Text("Login",
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), 
                ),        
              ),
              TextButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RegisterRoute,
                  (route) => false,
                );
              }, child: const  Text("Not registered yet?..Register here",
               style: TextStyle(color: Colors.black), 
                ),        
              ),
            ],
          ),
    );
  }
}
