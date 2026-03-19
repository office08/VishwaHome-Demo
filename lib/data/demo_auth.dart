import 'package:flutter/material.dart';
import '../data/mock_data.dart';

class DemoAuthProvider extends ChangeNotifier {
  DemoUser? _user;
  DemoUser? get currentUser => _user;
  bool get isLoggedIn => _user != null;

  void login(DemoUser user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
