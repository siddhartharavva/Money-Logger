import 'package:flutter/material.dart';
import 'package:money_logger/utilities/dialogs/generic_dialogs.dart';

Future<void> showCannotShareEmptyLogDialog(BuildContext context){
  return showGenericDialog<void>(
    context:context,
    title: 'Sharing',
    content: 'You cannot share an empty Log!',
    optionsBuilder: () => {
      'OK' : null,
    },
    );
}