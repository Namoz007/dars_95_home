import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinAuthView extends StatelessWidget {
  final Function(String) onPinEntered;
  final VoidCallback onBiometricAuth;
  final bool biometricAvailable;

  PinAuthView({required this.onPinEntered, required this.onBiometricAuth, this.biometricAvailable = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Lock'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your PIN to unlock the app',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Pinput(
              length: 4,
              onCompleted: onPinEntered,
            ),
            if (biometricAvailable) // Show the button only if biometrics are available
              Column(
                children: [
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onBiometricAuth,
                    child: Text('Use Biometric Authentication'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
