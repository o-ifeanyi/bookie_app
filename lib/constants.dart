import 'package:flutter/material.dart';

const Color kDarkBlue = Color(0xFF0A0E21);
const Color kBlueAccent = Color(0xFF2296F3);
const Color kLightBlack = Colors.black45;
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
