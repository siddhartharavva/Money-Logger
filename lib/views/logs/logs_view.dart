import 'package:flutter/material.dart';
import 'package:money_logger/constants/routes.dart';
import 'package:money_logger/enums/menu_action.dart';
import 'dart:developer'as devtools show log;
import 'package:money_logger/services/auth/auth_service.dart';
import 'package:money_logger/services/crud/log_service.dart';

class LogsView extends StatefulWidget {
  const LogsView({super.key});

  @override
  State<LogsView> createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {

  late final LogsService _logsService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState(){
    _logsService = LogsService();
    
    super.initState();
  }

  @override
  void dispose(){
    _logsService.close();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.black,
        title:const Text("Your logs",
          style: TextStyle(color: Colors.white)         
        ),//, style: TextStyle(color: Colors.white)),
        actions: [ 
          IconButton(onPressed: (){
              Navigator.of(context).pushNamed(newLogRoute);
          }, icon: const Icon(Icons.add),
          ),
            PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) { 
                case MenuAction.logout:
                  final shouldLogout   = await showlogOutDialog(context);
                  if(shouldLogout){
                    await AuthService.firebase().logOut();
                     // ignore: use_build_context_synchronously
                     await Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                       (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return[
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child : Text("Logout"),
                ),
              ];
            },
          )
        ],
      ),  
      body: FutureBuilder(
        future:_logsService.getOrCreateUser(email: userEmail),
          
        builder: (context, snapshot) {              
        debugPrint("Outer snapshot connection state: ${snapshot.connectionState}");
        debugPrint("Future state: ${snapshot.connectionState}");
        debugPrint("Future data: ${snapshot.data}");
        debugPrint("Future error: ${snapshot.error}");                  
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              devtools.log("still loading...");   
              return const CircularProgressIndicator();
              case ConnectionState.done:
              debugPrint("the user is: $userEmail");
              return StreamBuilder(
                stream: _logsService.allLogs,
                builder: (context, snapshot) {
                  debugPrint("Inner snapshot connection state: ${snapshot.connectionState}");
                  debugPrint("Inner snapshot data: ${snapshot.data}");

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text('Waiting for all notes...');
                    case ConnectionState.done:
                      return const Text('Tdone waiting for all notes...');
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const Text('done waiting for all notes...');//return const CircularProgressIndicator();
          }
        },
      ),
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