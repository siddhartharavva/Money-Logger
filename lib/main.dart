import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_logger/firebase_options.dart';
import 'package:money_logger/views/login_view.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MaterialApp(
      title: 'Flutter Demo', 
      theme: ThemeData(
          primarySwatch: Colors.grey,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      appBar: AppBar(
        backgroundColor: Colors.black,
        title : const Text("Login",
        style: TextStyle(color: Colors.white),

        ),
      ), 
      body: FutureBuilder(
        future:Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                ),
        builder:(context, snapshot) {
          switch (snapshot.connectionState){

          case ConnectionState.done:
          final user = FirebaseAuth.instance.currentUser;
          if(user?.emailVerified?? false){
            print("You are a verified user");
          }else{
            print('You need to verify your email first');
          }

            return const Text("Done");
        default:
        return const Text("Loading");
          }  
        }, 
      ), 
     );
  }
}