import 'package:bookie/constants.dart';
import 'package:bookie/screens/search_screen.dart';
import 'package:bookie/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
   void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  var readingNow;
  List<Widget> pageViewWidgets = [
    Container(
      child: Center(
        child: Text('Downloaded'),
      ),
    ),
    Container(
      child: Center(
        child: Text('Favourites'),
      ),
    ),
  ];

  var activeStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: kLightBlack,
  );

  Widget continueReading() {
    return Container(
      child: Center(
        child: Text('List goes here'),
      ),
    );
  }

  Widget continueReadingNull() {
    return Container(
      height: 240,
      child: Row(
        children: <Widget>[
          Container(
            height: 240,
            width: 170,
            decoration: BoxDecoration(
              color: kBlueAccent,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Icon(
                Icons.add,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Tap to find a book'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBarViewWidgets() {
    return Expanded(
      child: Column(
        children: <Widget>[
          TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: kLightBlack,
            labelStyle: activeStyle,
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Text(
                'Downloaded',
              ),
              Text(
                'Favourites',
              ),
            ],
          ),
          Expanded(child: TabBarView(children: pageViewWidgets)
              ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
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
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Continue reading',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kLightBlack,
                ),
              ),
              SizedBox(height: 5),
              readingNow != null ? continueReading() : continueReadingNull(),
              SizedBox(height: 5),
              tabBarViewWidgets(),
            ],
          ),
        ),
      ),
    );
  }
}
