
  // ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:money_logger/constants/routes.dart';
import 'package:money_logger/enums/menu_action.dart';
import 'dart:developer'as devtools show log;

import 'package:money_logger/services/auth/auth_service.dart';

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
                    await AuthService.firebase().logOut();
                     await Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
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