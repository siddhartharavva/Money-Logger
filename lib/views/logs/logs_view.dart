// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:money_logger/constants/colour_values.dart';
import 'package:money_logger/constants/routes.dart';
import 'package:money_logger/enums/menu_action.dart';
import 'package:money_logger/services/auth/auth_service.dart';
import 'package:money_logger/services/auth/bloc/auth_bloc.dart';
import 'package:money_logger/services/auth/bloc/auth_event.dart';
import 'package:money_logger/services/cloud/cloud_note.dart';
import 'package:money_logger/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:money_logger/utilities/dialogs/logout_dialog.dart';
import 'package:money_logger/views/logs/logsListView.dart';
  
  extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class LogsView extends StatefulWidget {
  const LogsView({super.key});

  @override
  _LogsViewState createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {
  late final FirebaseCloudStorage _logsService;
  
  String get userId => AuthService.firebase().currentUser!.id;



   

    @override
  void initState() {
    _logsService = FirebaseCloudStorage();
    
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColour,
      appBar: AppBar(
        backgroundColor: bottomBarColour,
        title: const Text(
          "Your logs",
          style: TextStyle(color: textColour),
        ),
   actions: [
    
         PopupMenuButton<MenuAction>(

            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showlogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  
                  value: MenuAction.logout,
                  child: Text("Logout",
                  style: TextStyle(color: textColour,)),
                ),
              ];
            },
          color: primaryColour, 

          iconColor: iconColor,
          iconSize: 35,
          ),
             
   ],
      ),
      body: StreamBuilder(
              stream:_logsService.allLogs(ownerUserId: userId), 
              builder: (context,snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if(snapshot.hasData){
                      final allLogs = snapshot.data as Iterable<CloudLog>;                 
                      return LogsListView(
                        logs: allLogs, 
                        onDeleteLog: (log) async{
                          await _logsService.deleteLog(documentId: log.documentId);
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
           ),
    floatingActionButton: 
    SizedBox(
      width:150,
      height: 50,
      child: FloatingActionButton(
        onPressed: () {
           Navigator.of(context).pushNamed(
                        createOrUpdateLogRoute,
                      );
        },
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // Border radius
        ),
        backgroundColor: primaryColour,
        child: const Text("+ADD NEW LOG",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: textColour,
            ),
           ), // Set the background color of the button
          ),
    ),
    
  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

  bottomNavigationBar: SizedBox(
        height: 75, // Set the width to match the screen width

    child: BottomAppBar(
          
          color: bottomBarColour, // Adjust color as needed
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
           const   Column(
            mainAxisAlignment: MainAxisAlignment.center,
           children: [
                Icon(Icons.home,
                size: 30,
              color: unhighlightedbBariconColor,
              ),
            
              SizedBox(height: 7) , // Add space between icon and text
            ],
          ),
                const SizedBox(width:spacing),
               
                Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
                IconButton(
                  onPressed: () {
                    // Add action for right icon
                  },
                  icon: const Icon(Icons.bar_chart,
                  size: 30,
                  color: bBariconColor,
                  ),
                  
                ),

            ],
          ),   
              ],
            ),
      
        ),
  ),

    );
    
  }

}
