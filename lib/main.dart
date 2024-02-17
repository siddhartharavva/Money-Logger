import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_logger/services/auth/bloc/auth_bloc.dart';
import 'package:money_logger/services/auth/bloc/auth_event.dart';
import 'package:money_logger/services/auth/bloc/auth_state.dart';
import 'package:money_logger/services/auth/firebase_auth_provider.dart';
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
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        homeRoute: (context) => const HomePage(),
        logRoute: (context) => const LogsView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state){
      if(state is AuthStateLoggedIn){
        return const LogsView();
      }else if (state is AuthStateNeedsVerification){
        return const VerifyEmailView();
      }else if (state is AuthStateLoggedOut){
        return const LoginView();
      }else {
        return const Scaffold(
          body:CircularProgressIndicator(),
        );
      }
    },);


  }
}
