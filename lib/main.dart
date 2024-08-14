import 'package:biometric_auth/delegates/auth_delegate.dart';
import 'package:biometric_auth/views/screens/home_view.dart';
import 'package:biometric_auth/views/screens/pin_auth_view.dart';
import 'package:biometric_auth/views/screens/set_pin_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'models/auth_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MVCD Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationCoordinator(),
    );
  }
}

class AuthenticationCoordinator extends StatefulWidget {
  @override
  _AuthenticationCoordinatorState createState() =>
      _AuthenticationCoordinatorState();
}

class _AuthenticationCoordinatorState extends State<AuthenticationCoordinator>
    implements AuthDelegate {
  late AuthController _authController;
  late AuthModel _authModel;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _authModel = context.read<AuthModel>();
    _authController = AuthController(this, _authModel);
    _init();
  }

  Future<void> _init() async {
    await _authController.loadPin();

    _biometricAvailable = await _authController.checkBiometrics();
    setState(() {}); // Update the UI after checking biometric availability
  }

  @override
  Widget build(BuildContext context) {
    if (_authModel.pinCode == null) {
      return SetPinView(onPinSet: _authController.savePin);
    }

    if (_authModel.isAuthenticated) {
      return HomeView();
    }

    return PinAuthView(
      onPinEntered: _authController.authenticateWithPin,
      onBiometricAuth: _authController.authenticateWithBiometrics,
      biometricAvailable: _biometricAvailable,
    );
  }

  @override
  void onAuthenticationSuccess() {
    setState(() {
      _authModel.isAuthenticated = true;
    });
  }

  @override
  void onAuthenticationFailed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Authentication Failed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void updateUI() {
    setState(() {});
  }
}
