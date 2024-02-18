import 'package:flutter/widgets.dart';
import 'package:money_logger/utilities/dialogs/generic_dialogs.dart';

Future<void> showPasswordResetSentDialog(BuildContext context){
  return showGenericDialog<void>(
    context: context, 
    title: 'Password reset', 
    content: 'We have now sent you a password reset link.Please check your email for more information', 
    optionsBuilder:() =>{
      'OK': null,
    } ,
  );
}