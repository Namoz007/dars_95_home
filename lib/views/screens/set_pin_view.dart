import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class SetPinView extends StatelessWidget {
  final Function(String) onPinSet;

  SetPinView({required this.onPinSet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set New PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Set a new PIN for app lock',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Pinput(
              length: 4,
              onCompleted: onPinSet,
            ),
            SizedBox(height: 20),
            Text(
              'This PIN will be used to unlock the app.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
