

import 'package:flutter/cupertino.dart';

class ProviderClass extends ChangeNotifier {
  List<Widget> pageListWidget = [];


  void addToPage(Widget widget) {
    pageListWidget.add(widget);
    notifyListeners();
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
}