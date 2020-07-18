import 'package:bookie/models/provider.dart';
import 'package:bookie/screens/search_screen.dart';
import 'package:bookie/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookie/screens/home_screen.dart';
import 'package:bookie/screens/store_screen.dart';
import 'package:provider/provider.dart';

class MyHome extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyHome> {
  static List<Widget> _screenOptions = [
    HomeScreen(),
    StoreScreen(),
  ];

  static int _selectedIndex = 0;

  BottomNavigationBarItem buildBottomNavigationBarItem(
      {String title, IconData icon}) {
    return BottomNavigationBarItem(
      title: Text(
        title,
      ),
      icon: Icon(
        icon,
      ),
      activeIcon: Icon(icon, color: Colors.blueAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: _selectedIndex == 0 ? Text('Home') : Text('Explore'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: IndexedStack(
            children: _screenOptions,
            index: _selectedIndex,
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Theme.of(context).accentColor,
            items: <BottomNavigationBarItem>[
              buildBottomNavigationBarItem(title: 'Home', icon: Icons.home),
              buildBottomNavigationBarItem(
                  title: 'Explore', icon: Icons.explore),
            ],
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
