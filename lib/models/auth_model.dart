import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  String? pinCode;
  bool isAuthenticated = false;

  AuthModel({this.pinCode, this.isAuthenticated = false});
}
