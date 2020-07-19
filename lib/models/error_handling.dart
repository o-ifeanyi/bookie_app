import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final Function onPressed;
  ErrorPage({this.onPressed});
  @override
  Widget build(BuildContext context) {
    var socketExceptionPage = Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 55),
        child: Image(image: AssetImage('images/connection_lost.png')),
      ),
    );

    return GestureDetector(
            onTap: onPressed,
            child: socketExceptionPage,
          );
  }
}
