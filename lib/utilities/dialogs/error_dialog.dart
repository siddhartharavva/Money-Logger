import 'package:flutter/material.dart';
import 'package:money_logger/utilities/dialogs/generic_dialogs.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
){
  return showGenericDialog(
    context: context, 
    title:'An error occured', 
    content: text, 
    optionsBuilder: () => {
      'OK': null,
    },
  );
}