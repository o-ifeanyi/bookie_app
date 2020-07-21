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
    SearchScreen(),
    SettingScreen(),
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

  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
        break;
      case 1:
        return 'Explore';
        break;
      case 2:
        return 'Search';
        break;
      case 3:
        return 'Setting';
        break;
      default:
        return '';
    }
  }

  //closes the app if current screen is the home screen else it returns to home screen
  Future<bool> close() {
    if (_selectedIndex == 0) {
      return Future.value(true);
    } else {
      setState(() {
        _selectedIndex = 0;
      });
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              getTitle(_selectedIndex),
            ),
          ),
          body: WillPopScope(
            onWillPop: () {
              return close();
            },
            child: IndexedStack(
              children: _screenOptions,
              index: _selectedIndex,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Theme.of(context).accentColor,
            unselectedItemColor: Colors.black54,
            items: <BottomNavigationBarItem>[
              buildBottomNavigationBarItem(title: 'Home', icon: Icons.home),
              buildBottomNavigationBarItem(
                  title: 'Explore', icon: Icons.explore),
              buildBottomNavigationBarItem(title: 'Search', icon: Icons.search),
              buildBottomNavigationBarItem(
                  title: 'Settings', icon: Icons.settings),
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
