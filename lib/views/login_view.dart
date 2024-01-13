import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_logger/constants/routes.dart';
import 'package:money_logger/services/auth/auth_exceptions.dart';
import 'package:money_logger/services/auth/auth_service.dart';
import 'package:money_logger/utilities/Show_Error_dialog.dart';



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
    return  Scaffold(backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(backgroundColor: Colors.black,
        title: const Text("Login",
          style: TextStyle(color: Colors.white)
        ),
        
      ),
      body: Column(
            children: [
              TextField(
                controller: _email,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Enter your email here",
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
          
                decoration: const InputDecoration(
                  hintText: "Enter the password here",
                  
          
                ),
              ),
              TextButton(
            
                style: TextButton.styleFrom(
                 backgroundColor:const Color.fromARGB(255, 0, 0, 0),
                 
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
                    if(user?.isEmailVerifed??false){
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
                  child: const Text("Login",
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), 
                ),        
              ),
              TextButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              }, child: const  Text("Not registered yet?..Register here",
               style: TextStyle(color: Colors.black), 
                ),        
              ),
            ],
          ),
    );
  }
}

