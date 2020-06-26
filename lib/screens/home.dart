import 'package:flutter/material.dart';
import 'package:bookie/screens/home_screen.dart';
import 'package:bookie/screens/settings_screen.dart';
import 'package:bookie/screens/shelf_screen.dart';
import 'package:bookie/screens/store_screen.dart';
import 'package:bookie/screens/profile_screen.dart';

class MyHome extends StatefulWidget {
  static String id = 'myHome';
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyHome> {
  static List<Widget> _screenOptions = [
    HomeScreen(),
    ShelfScreen(),
    StoreScreen(),
    SettingsScreen(),
  ];

  static List<String> _screenLabel = ['Home', 'Shelf', 'Store', 'Settings'];

  static String _label = 'Home';

  static int _selectedIndex = 0;

  BottomNavigationBarItem buildBottomNavigationBarItem(
      {String title, IconData icon}) {
    return BottomNavigationBarItem(
      title: Text(
        title,
        style: TextStyle(color: Colors.black45),
      ),
      icon: Icon(
        icon,
        color: Colors.black45,
      ),
      activeIcon: Icon(icon, color: Colors.blueAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            '$_label',
            style: TextStyle(color: Colors.black45),
          ),
          backgroundColor: Color(0xFFFAFAFA),
          elevation: 0.0,
          actions: <Widget>[
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ProfileScreen.id,
                );
              },
            )
          ],
        ),
        body: _screenOptions[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            buildBottomNavigationBarItem(title: 'Home', icon: Icons.home),
            buildBottomNavigationBarItem(
                title: 'Shelf', icon: Icons.library_books),
            buildBottomNavigationBarItem(
                title: 'Store', icon: Icons.shopping_cart),
            buildBottomNavigationBarItem(
                title: 'Profile', icon: Icons.settings),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
              _label = _screenLabel[index];
            });
          },
        ),
      ),
    );
  }
}
