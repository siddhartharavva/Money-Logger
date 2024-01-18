import 'package:flutter/material.dart';
import 'package:money_logger/services/auth/auth_service.dart';
import 'package:money_logger/views/home_page.dart';
import 'package:money_logger/views/logs/logs_view.dart';
import 'package:money_logger/views/login_view.dart';
import 'package:money_logger/views/logs/new_logs_view.dart';
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
        logRoute : (context) => const LogsView(),
        verifyEmailRoute : (context) => const VerifyEmailView(),
        newLogRoute: (context) => const NewLogsView(),
      },


    ),
  ); 
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:  AuthService.firebase().initialize(),
         
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {             
  
            case ConnectionState.done:
             final user = AuthService.firebase().currentUser;
             
             if(user != null){
              
              if(user.isEmailVerified ){
                return const LogsView();
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
