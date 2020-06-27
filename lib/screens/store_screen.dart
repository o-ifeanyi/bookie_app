import 'package:bookie/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  final List<Widget> containers = [
    Container(
      child: Center(
        child: Text('Page 1'),
      ),
    ),
    Container(
       child: Center(
        child: Text('Page 2'),
      ),
    ),
    Container(
       child: Center(
        child: Text('Page 3'),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Store'),
            bottom: TabBar(
              tabs: [
                Text('data'),
                Text('data'),
                Text('data'),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: TabBarView(children: containers),
        ));
  }
}
