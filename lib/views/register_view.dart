// ignore_for_file: use_build_context_synchronously
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_logger/constants/colour_values.dart';

import 'package:flutter/material.dart';

import 'package:money_logger/services/auth/auth_exceptions.dart';
import 'package:money_logger/services/auth/bloc/auth_bloc.dart';
import 'package:money_logger/services/auth/bloc/auth_event.dart';
import 'package:money_logger/services/auth/bloc/auth_state.dart';
import 'package:money_logger/utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if(state is AuthStateRegistering){
          if(state.exception is WeakPasswordException){
            await showErrorDialog(context, 'Weak password');
          }else if(state.exception is EmailAlreadyInUseException){
            await showErrorDialog(context, 'Email is Already in use');
          }else if(state.exception is GenericAuthException){
            await showErrorDialog(context, 'Failed to register');

          }else if(state.exception is EmailInvalidException){
            await showErrorDialog(context, 'Email is invalid');

          }
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColour,
        appBar: AppBar(
          backgroundColor: backgroundColour,
        ),
        body: Center(
          child: Column(
            children: [
              const Spacer(flex: 14),
              const Text(
                "Let's get started!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'RobotoRoman',
                  fontSize: 50.0,
                  color: textColour,
                ),
              ),
              const Spacer(flex: 2),
              const SizedBox(
                width: 246.21,
                height: 48,
                child: Text(
                  'Register to create logs and view the statistics',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RobotoRoman',
                    fontSize: 17.0,
                    color: unhighlightedTextColour,
                  ),
                ),
              ),
              const Spacer(flex: 10),
              SizedBox(
                width: 352,
                height: 56,
                child: TextField(
                  style: const TextStyle(color: textColour),
                  controller: _email,
                  autocorrect: false,
                 // autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: textColour),
                    ),
                    hintText: "Username or Email",
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: unhighlightedTextColour),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    hintStyle: const TextStyle(
                      fontFamily: 'RobotoRoman',
                      color: unhighlightedTextColour,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 4),
              SizedBox(
                width: 352,
                height: 56,
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  style: const TextStyle(color: textColour),
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: textColour),
                    ),
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: unhighlightedTextColour),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    hintStyle: const TextStyle(
                      fontFamily: 'RobotoRoman',
                      color: unhighlightedTextColour,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 4),
              SizedBox(
                height: 48,
                width: 352,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(primaryColour),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: const BorderSide(color: primaryColour)))),
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    context.read<AuthBloc>().add(AuthEventRegister(
                      email, 
                      password,
                      ),
                    );
                  },
                  child: const Text(
                    "REGISTER",
                    style: TextStyle(
                      color: textColour,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 100),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    const AuthEventLogOut(),
                  );
                },
                child: const Text(
                  "Already registered?.. login here",
                  style: TextStyle(color: unhighlightedTextColour),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
