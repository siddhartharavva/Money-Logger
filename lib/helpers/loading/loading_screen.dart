// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:money_logger/constants/constant_values.dart';
import 'package:money_logger/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
    factory LoadingScreen() => _shared;

  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

void show({
  required BuildContext context,
  required String text,
}){
    if(controller?.update(text) ?? false){
      return;
    }else{
      controller=showOverlay(
        context: context, 
        text: text,
      );
    }
}
void hide(){
  controller?.close();
  controller = null;
}

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }){

    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
           child:Container(
            constraints: BoxConstraints(
              maxWidth: size.width*0.8,
              maxHeight: size.height*0.8,
              minWidth: size.width*0.5,

            ),
            decoration: BoxDecoration(
              color:primaryColour,

              borderRadius: BorderRadius.circular(4.0),
              
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child:Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   const SizedBox(height: 10),
                     const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                   StreamBuilder(
                      stream: _text.stream, 
                      builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return Text(
                          snapshot.data as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color:textColour,
                          ),
                        );
                      }else{
                        return Container();
                      }
                    })
                  ],
                  ),
                ),
              )
           ) ,
          )
        );
      },
    );
  
   state.insert(overlay);

   return LoadingScreenController(close:(){
    _text.close;
    overlay.remove();
    return true;
   }, update: (text){
    _text.add(text);
    return true;
   
   });
  
  }
}