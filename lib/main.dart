import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_logger/firebase_options.dart';
import 'package:money_logger/views/home_page.dart';
import 'package:money_logger/views/login_view.dart';
import 'package:money_logger/views/register_view.dart';
import 'package:money_logger/views/verify_email_view.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MaterialApp(
      title: 'Flutter Demo', 
      theme: ThemeData(
          primarySwatch: Colors.grey,
      ),
      home: const HomePage(),
      routes: {
        '/login':(context)=> const LoginView(),
        '/register' : (context) => const RegisterView(),
        '/homepage' : (context) => const HomePage(),
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
              if(user.emailVerified){
                return const LogView();
              }else{
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

class LogView extends StatefulWidget {
  const LogView({super.key});

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.black,
        title:const Text("Page",
          style: TextStyle(color: Colors.white),
        )
      )
    );
  }
}
