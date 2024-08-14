
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import '../delegates/auth_delegate.dart';

class AuthController {
  final AuthDelegate _delegate;
  final AuthModel _model;
  final LocalAuthentication _auth = LocalAuthentication();

  AuthController(this._delegate, this._model);

  // Load PIN from local storage
  Future<void> loadPin() async {
    final prefs = await SharedPreferences.getInstance();
    _model.pinCode = prefs.getString('app_lock_pin');
    _delegate.updateUI();
  }

  // Save new PIN to local storage
  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_lock_pin', pin);
    _model.pinCode = pin;
    _model.isAuthenticated = true;
    _delegate.onAuthenticationSuccess();
  }

  // Authenticate using PIN
  Future<void> authenticateWithPin(String enteredPin) async {
    if (enteredPin == _model.pinCode) {
      _model.isAuthenticated = true;
      _delegate.onAuthenticationSuccess();
    } else {
      _delegate.onAuthenticationFailed();
    }
  }

  // Authenticate using biometric authentication (Face ID or Touch ID)
  Future<void> authenticateWithBiometrics() async {
    try {
      bool isAuthenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true, // Re-authenticate after app suspension
          useErrorDialogs: true,
        ),
      );
      if (isAuthenticated) {
        _model.isAuthenticated = true;
        _delegate.onAuthenticationSuccess();
      } else {
        _delegate.onAuthenticationFailed();
      }
    } catch (e) {
      _delegate.onAuthenticationFailed();
    }
  }

  // Check if biometric authentication is available
  Future<bool> checkBiometrics() async {
    return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
  }
}
