// ignore_for_file: unnecessary_import, use_build_context_synchronously
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_logger/constants/constant_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_logger/services/auth/auth_exceptions.dart';
import 'package:money_logger/services/auth/bloc/auth_bloc.dart';
import 'package:money_logger/services/auth/bloc/auth_event.dart';
import 'package:money_logger/services/auth/bloc/auth_state.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
         if (state is AuthStateLoggedOut) {
            if (state.exception is WrongPasswordException || state.exception is UserNotFoundException) {
                await showErrorDialog(context, 'Wrong Credentials');
            } else if (state.exception is GenericAuthException) {
                await showErrorDialog(
                    context, 'Authentication error');
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
                const Spacer(flex: 65),
                const Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RobotoRoman',
                    fontSize: 50.0,
                    color: textColour,
                  ),
                ),
                const Spacer(flex: 9),
                const SizedBox(
                  width: 246.21,
                  height: 48,
                  child: Text(
                    'Login to access your Logs and statistics',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'RobotoRoman',
                      fontSize: 17.0,
                      color: unhighlightedTextColour,
                    ),
                  ),
                ),
                const Spacer(flex: 47),
                SizedBox(
                  width: 352,
                  height: 56,
                  child: TextField(
                    style: const TextStyle(color: textColour),
                    controller: _email,
                    autocorrect: false,
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
                const Spacer(flex: 18),
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
                const Spacer(flex: 19),
                SizedBox(
                  height: 48,
                  width: 352,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColour),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: const BorderSide(
                                        color: primaryColour)))),
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      context.read<AuthBloc>().add(AuthEventLogIn(
                            email,
                            password,
                          ));
                    },
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                        color: textColour,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 4),                
                TextButton(
                  onPressed: () {
                   context.read<AuthBloc>().add(
                        const AuthEventForgotPassword(),
                      );
                  },
                  child: const Text(
                    "Forgot password?....Reset here",
                    style: TextStyle(color: unhighlightedTextColour),
                  ),
                ),
                const Spacer(flex: 400),
                TextButton(
                  onPressed: () {

                      final email = _email.text;
                      final password = _password.text;
                   context.read<AuthBloc>().add(
                         AuthEventRegister(email,password),
                      );

                  },
                  child: const Text(
                    "Not registered yet?..Register here",
                    style: TextStyle(color: unhighlightedTextColour),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
