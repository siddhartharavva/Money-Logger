
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:money_logger/constants/colour_values.dart';
import 'package:money_logger/services/cloud/cloud_note.dart';
import 'package:money_logger/utilities/dialogs/delete_dialog.dart';

typedef LogCallBack = void Function(CloudLog log);

class LogsListView extends StatelessWidget {
  final Iterable<CloudLog> logs;
  final LogCallBack onDeleteLog;
  final LogCallBack onTap;

  const LogsListView({
    super.key,
    required this.logs,
    required this.onDeleteLog,    
    required this.onTap,
    });



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs.elementAt(index);
          return ListTile(
            onTap: (){
              onTap(log);
            },
            title: Text(
              style:const TextStyle(
                color: textColour,
              ),
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
                icon: const Icon(
                  Icons.delete, 
                  color: Colors.white,
                  )                
                ),
            );
        }
    );
  }
}

