import 'package:flutter/material.dart';
import 'package:money_logger/utilities/dialogs/generic_dialogs.dart';

Future<bool> showlogOutDialog(BuildContext context){
  return showGenericDialog<bool>(
    context: context, 
    title:'Log out', 
    content: 'Are you sure you want to logout?', 
    optionsBuilder: () =>{
      'Cancel': false,
      'Log out': true,
    },
  ).then(
    (value) => value?? false,
  );
}