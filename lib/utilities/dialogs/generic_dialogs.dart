import 'package:flutter/material.dart';
import 'package:money_logger/constants/colour_values.dart';

typedef DialogOptionBuilder<T> = Map<String ,T?> Function();
Future<T?> showGenericDialog<T>({
  
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
    context: context, 
    builder: (context){
        return  AlertDialog(
           shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(4.0)),
           backgroundColor:primaryColour,
          title:Text(title,
          style:const TextStyle(color:textColour,
          )
          ),
          content: Text(content,
          style:const TextStyle(color:textColour,
          )
          ),
          actions: options.keys.map((optionTitle)  {
            final value = options[optionTitle];
            return TextButton(

              onPressed: () {
              if(value !=null){
                Navigator.of(context).pop(value);
              }else{
                Navigator.of(context).pop();
              }
            },
             child:Text(
              style: const TextStyle(color:textColour),
              optionTitle,
              )
            );
          }).toList(),
      );
    },
  );
}