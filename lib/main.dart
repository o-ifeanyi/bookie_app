import 'package:bookie/models/provider.dart';
import 'package:bookie/screens/home.dart';
import 'package:bookie/screens/registration_screen.dart';
import 'package:bookie/screens/search_screen.dart';
import 'package:bookie/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderClass(),
          child: MaterialApp(
          theme: ThemeData(),
          initialRoute: RegistrationScreen.id,
          routes: {
            MyHome.id: (context) => MyHome(),
            RegistrationScreen.id: (context) => RegistrationScreen(),
            SettingsScreen.id: (context) => SettingsScreen(),
            SearchScreen.id: (context) => SearchScreen(),
          },
        ),
    );
  }
}
