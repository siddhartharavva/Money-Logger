// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:money_logger/constants/colour_values.dart';
import 'package:money_logger/constants/routes.dart';
import 'package:money_logger/enums/menu_action.dart';
import 'package:money_logger/services/auth/auth_service.dart';
import 'package:money_logger/services/crud/log_service.dart';
import 'dart:developer' as devtools show log;


class LogsView extends StatefulWidget {
  const LogsView({super.key});

  @override
  _LogsViewState createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {
  late final LogsService _logsService;
  
  String get userEmail => AuthService.firebase().currentUser?.email ?? '';


   late Future<DatabaseUser> _data;

    @override
  void initState() {
    _logsService = LogsService();
    _data = _logsService.getOrCreateUser(email: userEmail);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColour,
      appBar: AppBar(
        backgroundColor: backgroundColour,
        title: const Text(
          "Your logs",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newLogRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showlogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    await Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                ),
              ];
            },
          )
        ],
        
      ),
      body: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {

          switch (snapshot.connectionState) {
            case ConnectionState.done:
            return StreamBuilder(
              stream:_logsService.allLogs, 
              builder: (context,snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                    return const Text("waiting for all notes");
                  default:
                    return const CircularProgressIndicator();
                }
              }
              
              );
              default:
              return const CircularProgressIndicator();
      
          }
        },
      ),
    );
  }
  @override
  void dispose() {
    _logsService.close();
    super.dispose();
  }

}


Future<bool> showlogOutDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Log out"),
        content: const Text("Are you sure you want to log out"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Log Out"),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}

