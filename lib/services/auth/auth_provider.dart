import 'dart:ffi';

import 'package:mynotes/services/auth/auth_user.dart';
import "dart:developer" as devtools show log;

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logOut();
  Future<void> sendVerification();
}
