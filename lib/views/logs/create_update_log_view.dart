
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_logger/constants/colour_values.dart';
import 'package:money_logger/constants/routes.dart';
import 'package:money_logger/enums/menu_action.dart';
import 'package:money_logger/services/auth/auth_service.dart';
import 'package:money_logger/services/auth/bloc/auth_bloc.dart';
import 'package:money_logger/services/auth/bloc/auth_event.dart';
import 'package:money_logger/utilities/dialogs/logout_dialog.dart';
import 'package:money_logger/utilities/generics/get_arguments.dart';
import "package:money_logger/services/cloud/cloud_note.dart";
import "package:money_logger/services/cloud/firebase_cloud_storage.dart";
import "package:money_logger/utilities/dialogs/cannot_share_empty_log_dialog.dart";
import 'package:share_plus/share_plus.dart';

class CreateUpdateLogView extends StatefulWidget {
  const CreateUpdateLogView({super.key});

  @override
  State<CreateUpdateLogView> createState() => _CreateUpdateLogViewState();
}

class _CreateUpdateLogViewState extends State<CreateUpdateLogView> {
  CloudLog? _log;
  late final  FirebaseCloudStorage _logsService;
  late final TextEditingController _textController;

@override
void initState(){
  _logsService = FirebaseCloudStorage();
  _textController = TextEditingController();
  super.initState();
}

void _textControllerListener() async {
  final log = _log;
  if(log == null){
    return;
  }
  final text = _textController.text;
  await _logsService.updateLog(
        documentId: log.documentId, 
        text: text,
      );
}

void _setupTextControllerListener(){
  
  _textController.removeListener(_textControllerListener);
  _textController.addListener(_textControllerListener);

}

  Future<CloudLog> createOrGetExistingLog(BuildContext context) async {
    
    final widgetLog = context.getArgument<CloudLog>();

    if(widgetLog != null)    {
      _log = widgetLog;
      _textController.text = widgetLog.text;
      return widgetLog;
    }
    final existingLog = _log;
    if(existingLog != null){
      return existingLog;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newLog = await  _logsService.createNewLog(ownerUserId: userId);
    _log = newLog;
    return newLog;
  }

void _deleteLogifTextIsEmpty() {

final log = _log;
if (_textController.text.isEmpty && log!= null) {
  _logsService.deleteLog(documentId: log.documentId);
  }
}



   void _saveLogIfTextNotEmpty() async{
    final log = _log;
    final text = _textController.text;
    if(log != null && text.isNotEmpty){
       await _logsService.updateLog(
        documentId: log.documentId, 
        text: text,
      );
    
    }
  }

@override
void dispose(){
  _deleteLogifTextIsEmpty();
  _saveLogIfTextNotEmpty();
  _textController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {  
    return Scaffold(backgroundColor:backgroundColour,
      appBar: AppBar(backgroundColor:bottomBarColour,
        leading: IconButton(
          icon:const Icon(
            Icons.arrow_back,
              color: iconColor, // Change the color of the back button
            ),
    onPressed: () {
           Navigator.of(context).pushNamedAndRemoveUntil(
                      logRoute,
                      (_) => false,
                    );
    },
  ),
        actions: [
          IconButton(onPressed: () async {
            final text = _textController.text;
            if(_log == null || text.isEmpty){
              await showCannotShareEmptyLogDialog(context);
            }else{
              Share.share(text);
            }
          },
          icon: const Icon(Icons.share,
          color: iconColor,),
          
          
          ),
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
        title: const Text("New Log",        
         style: TextStyle(color: textColour)) ,

      ),
      
      body:FutureBuilder(
        future: createOrGetExistingLog(context),
        builder:(context,snapshot) {
          switch(snapshot.connectionState){
           
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                style: const TextStyle(
                  color: textColour,
                ),
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'start typing text here...',
                  hintStyle: TextStyle(color: unhighlightedTextColour),
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),

    );
  }
}