import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCodeService extends ChangeNotifier {
  int? pinCode;
  Future<void> getPinCode() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    pinCode = sharedPreferences.getInt('pin');
  }

  Future<void> setPinCode(int pinCode) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('pin', pinCode);
  }
}
