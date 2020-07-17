import 'package:flutter/material.dart';

const kInputDecoration = InputDecoration(
  hintText: '',
  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black45, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
);

const kCursiveHeading = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.w900,
  fontFamily: 'Kaushan Script',
);

const kSearchResultTextStyle = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w300, fontFamily: 'Source Sans Pro');

const kActiveStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    // color: kLightBlack,
  );

final kDarkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Color(0xFF212121),
  brightness: Brightness.dark,
  backgroundColor: Color(0xFF212121),
  scaffoldBackgroundColor: Colors.black54,
  accentColor: Color(0xFF2296F3),
);

final kLightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Color(0xFF2296F3),
  brightness: Brightness.light,
  backgroundColor: Color(0xFFE5E5E5),
  scaffoldBackgroundColor: Colors.white,
  accentColor: Color(0xFF2296F3),
  dividerColor: Colors.white54,
);