
// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:money_logger/constants/constant_values.dart';
import 'package:money_logger/services/auth/auth_service.dart';
import 'package:money_logger/utilities/generics/get_arguments.dart';
import "package:money_logger/services/cloud/cloud_log.dart";
import "package:money_logger/services/cloud/firebase_cloud_storage.dart";
import "package:money_logger/utilities/dialogs/cannot_share_empty_log_dialog.dart";
import 'package:share_plus/share_plus.dart';

class CreateUpdateLogView extends StatefulWidget {
  const CreateUpdateLogView({super.key});
  
  @override
  State<CreateUpdateLogView> createState() => _CreateUpdateLogViewState();
}

class _CreateUpdateLogViewState extends State<CreateUpdateLogView> {
  CloudLog? _log;
    late DateTime _selectedDate;
          late String formattedDateTime = _selectedDate.toString();
          
Widget _buildIcon() {
  return Icon(
      iconshape,
      color: Colors.white,
      size:20,
    );
}
  late final  FirebaseCloudStorage _logsService;
  late final TextEditingController _textController;

  late var iconshape=Icons.fastfood_rounded;
@override
void initState(){
  _logsService = FirebaseCloudStorage();
    _selectedDate = DateTime.now();

  _textController = TextEditingController(text: formattedDateTime);

  super.initState();
}

void _textControllerListener() async {
  final log = _log;
  if(log == null){
    return;
  }
  final text = _textController.text;
  await _logsService.updateLog(
        documentId: log.documentId, 
        text: text,
      );
}

void _setupTextControllerListener(){
  
  _textController.removeListener(_textControllerListener);
  _textController.addListener(_textControllerListener);

}
void _deleteLogifTextIsEmpty() {

final log = _log;
if (_textController.text.isEmpty && log!= null) {
  _logsService.deleteLog(documentId: log.documentId);
  }
}

  
  Future<CloudLog> createOrGetExistingLog(BuildContext context) async {
    
    final widgetLog = context.getArgument<CloudLog>();

    if(widgetLog != null)    {
      _log = widgetLog;
      _textController.text = widgetLog.text;
      return widgetLog;
    }
    final existingLog = _log;
    if(existingLog != null){
      return existingLog;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newLog = await  _logsService.createNewLog(ownerUserId: userId);
    _log = newLog;
    return newLog;
  }



   void _saveLogIfTextNotEmpty() async{
    final log = _log;
    final text = _textController.text;
    if(log != null && text.isNotEmpty){
       await _logsService.updateLog(
        documentId: log.documentId, 
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
      appBar: AppBar(title: const Text("test"),
        backgroundColor:bottomBarColour,
        actions: [          
          IconButton(onPressed: () async {
            final text = _textController.text;
            if(_log == null || text.isEmpty){
              await showCannotShareEmptyLogDialog(context);
            }else{
              Share.share(text);
            }
          },
          icon: const Icon(Icons.share,
          color: iconColor,),
          
          ),

             
        ],

      ),
      
      body:FutureBuilder(
        future: createOrGetExistingLog(context),
        builder:(context,snapshot) {
          switch(snapshot.connectionState){
           
            case ConnectionState.done:
              _setupTextControllerListener();
              return Scaffold(                
                backgroundColor: backgroundColour,
                    body:Padding(                     
                      padding: const EdgeInsets.all(1),
                        child: Column(
                          children: [   
                            Row(
                            children: [   
                              const Spacer(flex:10) ,
                              _buildIcon(),
                              const Spacer(flex:10) ,
                              SizedBox(// ItemName
                                width: 252,
                                height: 56,
                                child: TextField(
                                  controller: _textController,
                                  style: const TextStyle(color: textColour),
                                  decoration:InputDecoration(
                                    filled: true,
                                    fillColor: primaryColour,
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: textColour),
                                    ),

                                    hintText: 'Item Name',
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: textColour),
                                      
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    hintStyle: const TextStyle(
                                      fontFamily: 'RobotoRoman',
                                      color: unhighlightedTextColour,
                                    ),
                                    ),
                                  ),
                                ),
                              SizedBox(//itemCost
                                width: 60,
                                height: 56,      
                                                
                                  child: TextField(                              
                                  style: const TextStyle(color: textColour),
                                  keyboardType:const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(                               
                                    filled: true,
                                    fillColor: primaryColour,
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: textColour),
                                    ),
                                    hintText: '    ₹',
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: textColour),
                                      
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    hintStyle: const TextStyle(
                                      fontFamily: 'RobotoRoman',
                                      color: unhighlightedTextColour,
                                    ),)),
                                  ),
                             
                            IconButton(//Delete button
                              onPressed: () async {            
                            
                              },                          
                              icon: const Icon(
                                Icons.delete, 
                                color: iconColor,
                              )                
                            ),
                            ], 
                            ),
                          ],
                        ),                                        
                  ),            
          bottomNavigationBar: BottomAppBar(  
          color:bottomBarColour,          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  decoration: BoxDecoration(
                  color: primaryColour, // Set the background color of the container
                  borderRadius: BorderRadius.circular(10), // Set the border radius
                    ),
                width: tagWidth,
                height: 56,
                 
                child: TextButton(
                
                  onPressed: () {
                  setState(() {
                    iconshape = Icons.local_grocery_store_rounded ;
                  });   
                  },
                  
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(
                        Icons.local_grocery_store_rounded,
                        size: 20, // Specify the icon you want to use
                        color: iconColor,
                        ),
                       Text("Staples",
                        style:TextStyle(
                          color: textColour,
                          fontSize: tagFontSize,
                        ), 
                      ),
                  ]), 
                ),
              ),
               Container(
                  decoration: BoxDecoration(
                  color: primaryColour, // Set the background color of the container
                  borderRadius: BorderRadius.circular(10), // Set the border radius
                    ),
                width: tagWidth,
                height: 56,
                 
                child: TextButton(
                
                  onPressed: () {
                                      
                  setState(() {
                    iconshape = Icons.fastfood_rounded ;
                  });                 
                   },
                  
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                       Icon(
                        Icons.fastfood_rounded, 
                        size: 20, // Specify the icon you want to use
                        color: iconColor,
                        ),
                       Text("Food",
                        style:TextStyle(
                          color: textColour,
                          fontSize: tagFontSize,
                        ), 
                      ),
                  ]), 
                ),
              ),
               Container(
                  decoration: BoxDecoration(
                  color: primaryColour, // Set the background color of the container
                  borderRadius: BorderRadius.circular(10), // Set the border radius
                    ),
                width: tagWidth,
                height: 56,
                 
                child: TextButton(                
                  onPressed: () {
                    setState(() {
                    iconshape = Icons.directions_car_filled_rounded ;
                  }); 

                  },
                  
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                                        

                    children: [
                       Icon(
                        Icons.directions_car_filled_rounded, // Specify the icon you want to use
                        color: iconColor,
                        size: 20, 

                        ),
                       Text("Travel",
                        style:TextStyle(
                          color: textColour,
                          fontSize: tagFontSize,
                        ), 
                      ),
                  ]), 
                ),
              ),
               Container(
                  decoration: BoxDecoration(
                  color: primaryColour, // Set the background color of the container
                  borderRadius: BorderRadius.circular(10), // Set the border radius
                    ),
                width: tagWidth,
                height: 56,
                 
                child: TextButton(
                
                  onPressed: () {
                  setState(() {
                      iconshape = Icons.miscellaneous_services_rounded  ;

                  });   
                  },
                  
                  child:const Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                       Icon(
                        Icons.miscellaneous_services_rounded, // Specify the icon you want to use
                        color: iconColor,
                        size: 20 ,                         
                        ),
                       Text("Misc",
                        style:TextStyle(
                          color: textColour,
                          fontSize: tagFontSize,
                        ), 
                      ),
                  ]), 

                  ),
                ),

            
            ],
          ),
),
              );
              
            default:
              return const Text("");
          }
        },
      ),

    );
  }
}
