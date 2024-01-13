import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_logger/firebase_options.dart';
import 'package:money_logger/views/home_page.dart';
import 'package:money_logger/views/login_view.dart';
import 'package:money_logger/views/register_view.dart';
import 'package:money_logger/views/verify_email_view.dart';
import 'package:money_logger/constants/routes.dart';
import 'dart:developer'as devtools show log;

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MaterialApp(
      title: 'Flutter Demo', 
      theme: ThemeData(
          primarySwatch: Colors.grey,
      ),
      home: const HomePage(),
      routes: {
        LoginRoute : (context)=> const LoginView(),
        RegisterRoute : (context) => const RegisterView(),
        HomeRoute : (context) => const HomePage(),
        LogRoute : (context) => const LogView(),
        VerifyEmailRoute : (context) => const VerifyEmailView(),
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
enum MenuAction{logout}

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
        title:const Text("Main Ui",
          style: TextStyle(color: Colors.white)         
        ),//, style: TextStyle(color: Colors.white)),
        actions: [ 
            PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) { 
                case MenuAction.logout:
                  final shouldLogout   = await showlogOutDialog(context);
                  if(shouldLogout){
                    await FirebaseAuth.instance.signOut();
                     await Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginRoute,
                       (_) => false,
                    );
                  }
                  devtools.log(shouldLogout.toString());
                  break;
              }
            },
            itemBuilder: (context) {
              return[
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child : Text("Logout"),
                ),
              ];
          },)
        ],
      ),
      body: const Text("Hello world"),
    );
  }
}

Future<bool> showlogOutDialog(BuildContext context) async {
    return await showDialog<bool>(
    context: context,
    builder: (context){
      return  AlertDialog(
        title: const Text("Log out"),
        content: const Text("Are you sure you want to log out"),
        actions: [
        TextButton(onPressed:() {
          Navigator.of(context).pop(false);
          }, 
          child: const Text("Cancel"),
        ),
        TextButton(onPressed:() {
          Navigator.of(context).pop(true);          
          }, 
          child:  const Text("log out"),
        ),
    
        ],

      );
    },

  ).then((value) => value ?? false);

}