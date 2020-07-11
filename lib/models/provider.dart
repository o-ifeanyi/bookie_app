
import 'package:bookie/models/download_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ProviderClass extends ChangeNotifier {
  List<Widget> pageListWidget = [];
  var dlDB = DownloadsDB();
  bool downloaded = false;

  void addToPage(Widget widget) {
    pageListWidget.add(widget);
    notifyListeners();
  }
}
  // static bool userIsSignedIn = false;

  // bool getStatus() {
  //   return userIsSignedIn;
  // }

  // void signIn() {
  //   userIsSignedIn = true;
  //   notifyListeners();
  // }

  // void signOut() {
  //   userIsSignedIn = false;
  //   notifyListeners();
  // }
