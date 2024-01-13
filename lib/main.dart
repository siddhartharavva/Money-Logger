import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_logger/firebase_options.dart';
import 'package:money_logger/views/home_page.dart';
import 'package:money_logger/views/log_view.dart';
import 'package:money_logger/views/login_view.dart';
import 'package:money_logger/views/register_view.dart';
import 'package:money_logger/views/verify_email_view.dart';
import 'package:money_logger/constants/routes.dart';
import 'dart:developer'as devtools show log;

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MaterialApp(
      title: 'Money Logger', 
      theme: ThemeData(
          primarySwatch: Colors.grey,
      ),
      home: const HomePage(),
      routes: {
        loginRoute : (context)=> const LoginView(),
        registerRoute : (context) => const RegisterView(),
        homeRoute : (context) => const HomePage(),
        logRoute : (context) => const LogView(),
        verifyEmailRoute : (context) => const VerifyEmailView(),
      },


    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:   Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
         ),
         
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {             
  
            case ConnectionState.done:
             final user = FirebaseAuth.instance.currentUser;
             
             if(user != null){
                user.reload();

              if(user.emailVerified){
                return const LogView();
              }else{
                devtools.log(user.toString());
                return const VerifyEmailView();
              }
             }else{

                return const LoginView();            
                
             }
             
            default:
              return const HomeView();
          }
        },
      );
  }
}
