import 'package:flutter/material.dart';
import 'package:money_logger/services/crud/log_service.dart';
import 'package:money_logger/utilities/dialogs/delete_dialog.dart';

typedef DeleteLogCallBack = void Function(DatabaseLog log);

class LogsListView extends StatelessWidget {

  

  final List<DatabaseLog> logs;
  final DeleteLogCallBack onDeleteLog;

  const LogsListView({
    super.key,
    required this.logs,
    required this.onDeleteLog,    
    });



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
          return ListTile(
            title: Text(
              log.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                onPressed: () async {            
                  final shouldDelete = await showDeleteDialog(context);
                  if(shouldDelete){
                    onDeleteLog(log);
                  }
                },
                icon: const Icon(Icons.delete)                
                ),
            );
        }
    );
  }
}

