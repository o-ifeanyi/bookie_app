import 'package:flutter/material.dart';

class ErrorHandling {
  static void handleSocketException(context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Network unavailable. Try again later'),
        duration: Duration(seconds: 5),
      ),
    );
  }
}

var socketExceptionPage = Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.cloud_off,
        color: Colors.black45,
        size: 100,
      ),
      Text(
        'Oops',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Text('Please check your internet connection!'),
      Text('Tap to retry'),
    ],
  ),
);

class ErrorPage extends StatelessWidget {
  final Function onPressed;
  ErrorPage(this.onPressed);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: socketExceptionPage,
    );
  }
}
