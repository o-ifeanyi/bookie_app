import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static String id = 'settingScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Center(
        child: Text(
          'Settings Screen',
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}