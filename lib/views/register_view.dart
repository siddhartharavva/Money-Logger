
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text("Register",
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
                 backgroundColor: const Color.fromARGB(255, 79, 79, 79),
                 
                  ),
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                try{
                  final userCredential = await  FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                    );
                    print(userCredential);
                }on FirebaseAuthException catch(e){
                  if(e.code == "weak-password"){
                  print("Password should be atleast 6 characters");
                }
                else if(e.code == "email-already-in-use"){
                  print("The email address is already in use");
                }
                else if(e.code == 'invalid-email'){
                  print("Invalid email entered");
                  }
                 }
                },
          
                  child: const Text("Register",
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), 
                ),
              ),
              TextButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
              }, child: const Text("Already registered?.. login here")),
            ],
          ),
    );
  }
  }
