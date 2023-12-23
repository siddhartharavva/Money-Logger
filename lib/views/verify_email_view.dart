
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            const Text("Verify your email address",
            textScaler: TextScaler.linear(2.5),
            ),
            TextButton(
                style: TextButton.styleFrom(
                 backgroundColor: const Color.fromARGB(255, 79, 79, 79),   
                ),
              onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            }, 
            child: const Text("Verify",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)
            ), 

            ),
          ),
        ],
      ),
    );
  }
}