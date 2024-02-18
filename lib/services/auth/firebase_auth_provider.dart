import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_logger/firebase_options.dart';
import 'package:money_logger/services/auth/auth_user.dart';
import 'package:money_logger/services/auth/auth_provider.dart';
import 'package:money_logger/services/auth/auth_exceptions.dart';

import 'package:firebase_auth/firebase_auth.dart' 
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      } else if(e.code == 'invalid-email') {
        throw EmailInvalidException();
      }else{
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException();
      }
    }on FirebaseAuthException catch(e){
      debugPrint(e.toString());
      if(e.code =='user-not-found'){
        throw UserNotFoundException();
      }else if(e.code == 'wrong-password'){
        throw WrongPasswordException();
      }else{
        throw GenericAuthException();
      }
    }catch (_){
      throw GenericAuthException();
    }
    
    

  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInException();
    }
  }
  
  @override
  Future<void> sendPasswordReset({required String toEmail})async  {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e){
      switch(e.code){
        case'firebase_auth/invalid-email':
          throw EmailInvalidException();
        case 'firebase-auth/user-not-found':
          throw UserNotFoundException(); 
        default:
          throw GenericAuthException();
      }
    } catch(_){
     throw GenericAuthException();
    }
  }
}
