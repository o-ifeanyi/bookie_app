import 'package:flutter/material.dart';
import 'package:bookie/screens/home_screen.dart';
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
    StoreScreen(),
    ProfileScreen(),
  ];

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
        body: IndexedStack(
          children: _screenOptions,
          index: _selectedIndex,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            buildBottomNavigationBarItem(title: 'Home', icon: Icons.home),
            buildBottomNavigationBarItem(
                title: 'Store', icon: Icons.shopping_cart),
            buildBottomNavigationBarItem(
                title: 'Profile', icon: Icons.person),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
