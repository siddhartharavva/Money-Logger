
// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:money_logger/constants/constant_values.dart';


class CreateUpdateLogView extends StatefulWidget {
  const CreateUpdateLogView({super.key});
  
  @override
  State<CreateUpdateLogView> createState() => _CreateUpdateLogViewState();
}

class _CreateUpdateLogViewState extends State<CreateUpdateLogView> {

          
Widget _buildIcon() {
  return Icon(
      iconshape,
      color: Colors.white,
      size:20,
    );
}
  late final TextEditingController _textController;

  late var iconshape=Icons.fastfood_rounded;
@override
void initState(){
  _textController = TextEditingController();
  super.initState();
}

@override
void dispose(){
  _textController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {  
    return Scaffold(backgroundColor:backgroundColour,
      appBar: AppBar(title: ,
        backgroundColor:bottomBarColour,
      ),
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
              
           
          }
        }
