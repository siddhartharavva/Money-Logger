// ignore_for_file: unnecessary_import, use_build_context_synchronously
import 'package:money_logger/constants/colour_values.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_logger/constants/routes.dart';
import 'package:money_logger/services/auth/auth_exceptions.dart';
import 'package:money_logger/services/auth/auth_service.dart';
import 'package:money_logger/utilities/dialogs/error_dialog.dart';



class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(backgroundColor: backgroundColour,
      appBar: AppBar(backgroundColor: backgroundColour,

        
      ),
      body: Center(
        child:Column(
            children: [
              const Spacer(flex:14),

              const Text('Login',
              textAlign: TextAlign.center,

              style: TextStyle(fontFamily: 'RobotoRoman',
                  fontSize: 50.0,
                  color: textColour,
                  

                ),
              ),
              const Spacer(flex:2),
               const SizedBox(
                width:246.21 ,
                height:48,
                child: Text('Login to access your Logs and statistics',
                  textAlign: TextAlign.center,

                  style: TextStyle(fontFamily: 'RobotoRoman',
                  fontSize: 17.0,
                  color: unhighlightedTextColour,

                ),
              ),
               ),
               const Spacer(flex:10),
              SizedBox(
                width: 352,
                height: 56,
              child: TextField(
                style: const TextStyle(color: textColour),
                
                controller: _email,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:  InputDecoration(
                focusedBorder:const OutlineInputBorder(
                borderSide: BorderSide(color: textColour),
                ),
                  hintText: "Username or Email",
                  border: OutlineInputBorder(
                  borderSide: const  BorderSide(color: unhighlightedTextColour),
                  borderRadius: BorderRadius.circular(1),
                ),
                  hintStyle: const TextStyle(fontFamily: 'RobotoRoman',
                  color: unhighlightedTextColour,
                  ),
                ),
              ),),
              const Spacer(flex:4),
              SizedBox(
                width: 352,
                height: 56,              
              child: TextField(
                controller: _password,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                style: const TextStyle(color: textColour),
                decoration:  InputDecoration(

                focusedBorder:const OutlineInputBorder(
                borderSide: BorderSide(color: textColour),
                ),                  
                  hintText: "Password",
                  border: OutlineInputBorder(
                  borderSide: const  BorderSide(color: unhighlightedTextColour),
                  borderRadius: BorderRadius.circular(1),
                ),                  
                  hintStyle:const TextStyle(fontFamily: 'RobotoRoman',
                  color: unhighlightedTextColour,
                  ),
                  
          
                ),
              ),),
              const Spacer(flex:4),
              SizedBox(
                height: 48,
                width: 352,
              child: TextButton(     
               style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(primaryColour),

                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: const BorderSide(color:primaryColour)
                    )
                   )           
              ),
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                 try{
                    await AuthService.firebase().logIn(
                      email: email, 
                      password: password,
                    );
                 
                    final user = AuthService.firebase().currentUser;
                    if(user?.isEmailVerified??false){
                         Navigator.of(context).pushNamedAndRemoveUntil(
                        logRoute,
                        (route) => false,
                      );

                    }else{
                      showErrorDialog(context, "Verify Your email");
                          Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (route) => false,
                      );

                    }

                }on UserNotFoundException{
                    await showErrorDialog(
                    context,
                    'User is not found',
                    );
                }on WrongPasswordException{
                    await showErrorDialog(
                    context,
                    'Wrong password',
                    );
                }on GenericAuthException{
                    await showErrorDialog(
                    context,
                    'Authentication Error',
                    );
                } 
                  
                },
                  child: const Text("LOGIN",
                  style: TextStyle(
                    color: textColour,
                    fontSize: 20.0,
                    ), 
                ),        
              ),
              ),
              const Spacer(flex:100),
              TextButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              }, child: const  Text("Not registered yet?..Register here",
               style: TextStyle(color: unhighlightedTextColour), 
                ),        
              ),
            ],
          ),
    )
    );
  }
}

