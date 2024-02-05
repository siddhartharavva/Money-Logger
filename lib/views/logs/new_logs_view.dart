import 'package:flutter/material.dart';
import 'package:money_logger/constants/colour_values.dart';
import 'package:money_logger/services/auth/auth_service.dart';
import 'package:money_logger/services/crud/log_service.dart';

class NewLogsView extends StatefulWidget {
  const NewLogsView({super.key});

  @override
  State<NewLogsView> createState() => _NewLogsViewState();
}

class _NewLogsViewState extends State<NewLogsView> {
  DatabaseLog? _log;
  late final  LogsService _logsService;
  late final TextEditingController _textController;

@override
void initState(){
  _logsService = LogsService();
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
    log: log, 
    text: text,
  );
}

void _setupTextControllerListener(){
  
  _textController.removeListener(_textControllerListener);
  _textController.addListener(_textControllerListener);

}

  Future<DatabaseLog> createNewLog() async {
    final existingLog = _log;
    if(existingLog != null){
      return existingLog;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _logsService.getUser(email: email);
    return await  _logsService.createLog(owner: owner);
  }

void _deleteLogifTextIsEmpty() {

final log = _log;
if (_textController.text.isEmpty && log!= null) {
  _logsService.deleteLog(id: log.id);
  }
}



   void _saveLogIfTextNotEmpty() async{
    final log = _log;
    final text = _textController.text;
    if(log != null && text.isNotEmpty){
       await _logsService.updateLog(
        log: log, 
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
      appBar: AppBar(backgroundColor:backgroundColour,
        title: const Text("New Log",
         style: TextStyle(color: Colors.white)) ,
      ),
      body:FutureBuilder(
        future: createNewLog(),
        builder:(context,snapshot) {
          switch(snapshot.connectionState){
           
            case ConnectionState.done:
              _log = snapshot.data as DatabaseLog;
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'start typing text here...',
                  hintStyle: TextStyle(color: Colors.white),
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