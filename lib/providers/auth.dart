import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer timer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _token != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (_expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['idToken'];
    _userId = extractedUserData['localId'];
    _expiryDate = expiryDate;

    notifyListeners();
    return true;
  }

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA4qfkgglJCyuRgLNLNI08kOdwolBungKo');
    final response = await http.post(url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    print(response.body);
  }

  Future<void> Login(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA4qfkgglJCyuRgLNLNI08kOdwolBungKo');

    final response = await http.post(url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    final result = json.decode(response.body);

    _token = result['idToken'];
    _userId = result['localId'];
    _expiryDate =
        DateTime.now().add(Duration(seconds: int.parse(result['expiresIn'])));

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate.toIso8601String()
    });
    prefs.setString('userData', userData);
  }

  Future<void> Logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    timer.cancel();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // prefs.remove('userData');
  }

  void autoLogout() {
    if (timer != null) {
      return timer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    timer = Timer(Duration(seconds: timeToExpiry), Logout);
  }
}
