import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static String id = 'profileScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Center(
        child: Text(
          'Profile Screen',
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