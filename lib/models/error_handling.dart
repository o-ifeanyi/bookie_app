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
  child: Image(image: AssetImage('images/connection_lost.png')),
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
