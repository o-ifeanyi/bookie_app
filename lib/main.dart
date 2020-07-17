import 'package:bookie/constants.dart';
import 'package:bookie/models/provider.dart';
import 'package:bookie/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((pref) {
    bool isDark = pref.getBool('theme') ?? false;
    runApp(ChangeNotifierProvider(
      create: (_) => ProviderClass(isDark ? kDarkTheme : kLightTheme),
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(
      builder: (context, provider, child) {
        return MaterialApp(
          theme: provider.getTheme(),
          home: MyHome(),
        );
      },
    );
  }
}
