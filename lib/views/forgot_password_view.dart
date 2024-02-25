import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_logger/constants/constant_values.dart';
import 'package:money_logger/services/auth/bloc/auth_bloc.dart';
import 'package:money_logger/services/auth/bloc/auth_event.dart';
import 'package:money_logger/services/auth/bloc/auth_state.dart';
import 'package:money_logger/utilities/dialogs/error_dialog.dart';
import 'package:money_logger/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  late final TextEditingController _controller;

  @override
  void initState(){
    _controller = TextEditingController();
    super.initState();
  }

 @override
  void dispose(){
    _controller.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if(state is AuthStateForgotPassword){
          if(state.hasSentEmail){
            _controller.clear();
            await showPasswordResetSentDialog(context);            
          }
          if(state.exception!= null){
            // ignore: use_build_context_synchronously
            await showErrorDialog(context, 'We could not process your request. Please make sure that you are a registered user');
          }
        }

      },
      child:Scaffold(
          backgroundColor: backgroundColour,
          appBar: AppBar(
            backgroundColor: backgroundColour,
          ),
        body:Center(
          child: Column(
            children: [
                const Spacer(flex: 29),
                const Text(
                  'Forgot Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'RobotoRoman',
                    fontSize: 50.0,
                    color: textColour,
                  ),
                ),
                const Spacer(flex: 4),
                const SizedBox(
                  width: 246.21,
                  height: 48,
                  child: Text(
                    'Enter your email to get a password reset link',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'RobotoRoman',
                      fontSize: 17.0,
                      color: unhighlightedTextColour,
                    ),
                  ),
                ),
                const Spacer(flex: 57),
                SizedBox(
                  width: 352,
                  height: 56,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,

                    controller: _controller,
                    autocorrect: false,
                  //  autofocus: true,
                    enableSuggestions: false,
                    style: const TextStyle(color: textColour),
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: textColour),
                      ),
                      hintText: "Your email address",
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
                const Spacer(flex: 8),           
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
                    onPressed: ()  {
                final email = _controller.text;
                context.read<AuthBloc>().add(AuthEventForgotPassword(email:email),
                                        );

                    },
                    child: const Text(
                      "Send me password reset link",
                      style: TextStyle(
                        color: textColour,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),  
                const Spacer(flex: 200),
                TextButton(
                  onPressed: () {
                      context.read<AuthBloc>().add(const AuthEventLogOut(),
                      );
                  },
                  child: const Text(
                    "Done resetting?...Login here",
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