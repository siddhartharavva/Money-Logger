
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:money_logger/constants/constant_values.dart';
import 'package:money_logger/services/cloud/cloud_log.dart';
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
    return ListView.separated(
      itemCount: logs.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(
        color: backgroundColour, 
        thickness: 5, 
        height: 5, 
  ),
      itemBuilder: (context, index) {
        final log = logs.elementAt(index);
           return Padding(

             padding: const EdgeInsets.fromLTRB(0.0,7, 10.0, 0.0),
               child: ListTile(
                
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)
                    ),
                    tileColor:primaryColour, 
               
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
                      color: iconColor,
                      )                
                    ),
                ),
            
           );
        }
    );
  }
}

