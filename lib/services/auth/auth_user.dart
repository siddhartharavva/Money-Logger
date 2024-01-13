import 'package:firebase_auth/firebase_auth.dart'  show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser{
  final bool isEmailVerifed;
  const AuthUser(this.isEmailVerifed);

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}

