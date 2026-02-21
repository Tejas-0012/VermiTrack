import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = true;
  String _userName = 'Rajesh Kumar';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;

  void login(String name) {
    _isLoggedIn = true;
    _userName = name;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
