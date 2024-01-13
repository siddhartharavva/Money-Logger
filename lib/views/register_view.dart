
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:money_logger/constants/routes.dart';
import 'package:money_logger/services/auth/auth_exceptions.dart';
import 'package:money_logger/services/auth/auth_service.dart';
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
                 await AuthService.firebase().createUser(
                    email: email, 
                    password: password,
                    );
                   await AuthService.firebase().sendEmailVerification();
                        Navigator.of(context).pushNamed(verifyEmailRoute);
                }on  WeakPasswordException{

                   await showErrorDialog(context,
                    "enter a stronger password",
                    );
                }on EmailAlreadyInUseException{
                  await showErrorDialog(context,
                   "email entered already in use",
                  );    
                }on GenericAuthException{
                  await showErrorDialog(context,
                   "Registering error",
                  );    
                 }      
                },
          
                  child: const Text("Register",
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), 
                ),
              ),
              TextButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
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
