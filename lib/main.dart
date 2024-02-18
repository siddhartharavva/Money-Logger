import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_logger/constants/colour_values.dart';
import 'package:money_logger/helpers/loading/loading_screen.dart';
import 'package:money_logger/services/auth/bloc/auth_bloc.dart';
import 'package:money_logger/services/auth/bloc/auth_event.dart';
import 'package:money_logger/services/auth/bloc/auth_state.dart';
import 'package:money_logger/services/auth/firebase_auth_provider.dart';
import 'package:money_logger/views/forgot_password_view.dart';
import 'package:money_logger/views/login_view.dart';
import 'package:money_logger/views/logs/logs_view.dart';
import 'package:money_logger/views/logs/create_update_log_view.dart';
import 'package:money_logger/views/register_view.dart';
import 'package:money_logger/views/verify_email_view.dart';
import 'package:money_logger/constants/routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Money Logger',
      theme: ThemeData(fontFamily: 'RobotoRoman'),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        logRoute: (context) => const LogsView(),
        createOrUpdateLogRoute: (context) => const CreateUpdateLogView(),
              },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state){
        if(state.isLoading){
          LoadingScreen().show(
            context: context,
            text:state.loadingText ?? 'please wait a moment',
            );
        }else{
          LoadingScreen().hide();
        }
      },
      builder: (context, state){
      if(state is AuthStateLoggedIn){
        return const LogsView();
      }else if (state is AuthStateNeedsVerification){
        return const VerifyEmailView();
      }else if (state is AuthStateLoggedOut){
        return const LoginView();
      }else if (state is AuthStateForgotPassword){
        return const ForgotPasswordView();
      } else if(state is AuthStateRegistering) {
        return const RegisterView();
      }else{
        return const Scaffold(
          backgroundColor: backgroundColour,
        );
      }
    },);


  }
}
