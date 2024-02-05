import 'package:flutter/material.dart';
import 'package:money_logger/utilities/dialogs/generic_dialogs.dart';

Future<bool> showDeleteDialog(BuildContext context){
  return showGenericDialog<bool>(
    context: context, 
    title:'Delete', 
    content: 'Are you sure you want to Delete?', 
    optionsBuilder: () =>{
      'Cancel': false,
      'Yes': true,
    },
  ).then(
    (value) => value?? false,
  );
}