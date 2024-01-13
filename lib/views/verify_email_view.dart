
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:money_logger/constants/routes.dart';
import 'package:money_logger/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}


class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(backgroundColor: Colors.black,
        title: const Text("Verification",
          style: TextStyle(color: Colors.white)
        ),
        
      ),
      body: Column(
          children: [
            const Text("Verificaiton email has been sent,Open the email to verify your account",
            textScaler: TextScaler.linear(2.5),
            ),
            TextButton(
                style: TextButton.styleFrom(
                 backgroundColor: const Color.fromARGB(255, 79, 79, 79),   
                ),
              onPressed: () async {
              AuthService.firebase().sendEmailVerification();
              
            }, 
            child: const Text("Resend Verification email",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)
            ), 

            ),
          ),
          TextButton(
                style: TextButton.styleFrom(
                 backgroundColor: const Color.fromARGB(255, 79, 79, 79),   
                ),
              onPressed: () {
                 Navigator.of(context).pushNamedAndRemoveUntil(
                  homeRoute,
                (route) => false,
              );
            }, 
            child: const Text("Click twice after verification",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)
            ), 

            ),
          ),
          TextButton(
                style: TextButton.styleFrom(
                 backgroundColor: const Color.fromARGB(255, 79, 79, 79),   
                ),
              onPressed: () async {
                 await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                 );
            }, 
            child: const Text("Restart",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)
            ), 

            ),
          ),  
        ],
      ),
    );
  }
}