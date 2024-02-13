// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:money_logger/constants/colour_values.dart';
import 'package:money_logger/constants/routes.dart';
import 'package:money_logger/enums/menu_action.dart';
import 'package:money_logger/services/auth/auth_service.dart';
import 'package:money_logger/services/crud/log_service.dart';

import 'package:money_logger/utilities/dialogs/logout_dialog.dart';
import 'package:money_logger/views/logs/logsListView.dart';
    


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
              
              Navigator.of(context).pushNamed(createOrUpdateLogRoute);
            },
            icon: const Icon(
              Icons.add, 
              color:textColour,
            ),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showlogOutDialog(context);
                  if (shouldLogout) {
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
                  case ConnectionState.active:
                    if(snapshot.hasData){
                      final allLogs = snapshot.data as List<DatabaseLog>;
                 
                      debugPrint(allLogs.toString());
                      return LogsListView(
                        logs: allLogs, 
                        onDeleteLog: (log) async{
                          await _logsService.deleteLog(id: log.id);
                        },
                        onTap: (log) async {
                         Navigator.of(context).pushNamed(
                          createOrUpdateLogRoute,
                          arguments: log,
                          
                        );

                        },
                        );
                  

                    }else{
                      return const CircularProgressIndicator();

                    }
                   
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

}


