import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/app/core/navigator/todo_list_navigator.dart';
import 'package:todo_list/app/services/user/user_service.dart';

class MyAuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final UserService _userService;

  MyAuthProvider(
      {required FirebaseAuth firebaseAuth, required UserService userService})
      : _firebaseAuth = firebaseAuth,
        _userService = userService;

  Future<void> logout() => _userService.logout();

  User? get user => _firebaseAuth.currentUser;

  void loadListener() {
    _firebaseAuth.userChanges().listen((_) => notifyListeners());
    _firebaseAuth.authStateChanges().listen((user) {
      // se o user for diferente de null o user está logado
      if (user != null) {
        TodoListNavigator.to!
            .pushNamedAndRemoveUntil('/home', (route) => false);
      } else {
        // se for null, ele deslogou
        TodoListNavigator.to!
            .pushNamedAndRemoveUntil('/login', (route) => false);
      }
    });
  }
}
