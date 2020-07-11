import 'package:bookie/constants.dart';
import 'package:bookie/models/get_token.dart';
import 'package:bookie/models/signin_signup.dart';
import 'package:bookie/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

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
  void isUserSignedIn() async {
    isSignedIn = (await _googleSignIn.isSignedIn());
    setState(() {});
    print('User is Signed in: $isSignedIn');
  }

  bool isSignedIn = false;
  bool accessGranted = false;
  var readingNow;
  List<Widget> pageViewWidgets = [
    Container(
      child: Center(
        child: Text('Recommended'),
      ),
    ),
    Container(
      child: Center(
        child: Text('History'),
      ),
    ),
  ];

  var activeStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: kLightBlack,
  );
  Widget continueReading() {
    //TODO: get user bookshelf 'reading now' and diplay in a listview builder.
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

  Widget recommended() {
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
                'Recommended',
              ),
              Text(
                'History',
              ),
            ],
          ),
          Expanded(child: TabBarView(children: pageViewWidgets)
              ),
        ],
      ),
    );
  }

  Widget recommendedNull(context) {
    return Container(
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Getting started',
              style: activeStyle,
            ),
            ListTile(
              leading: Icon(FontAwesome.google),
              title: Text(
                'Step one',
              ),
              subtitle: Text('Sign in with google'),
              trailing: isSignedIn
                  ? Icon(Icons.done_all, color: Colors.green)
                  : Icon(Icons.cancel, color: Colors.red),
              onTap: () async {
                try {
                  await SignInSignUp().handleGoogleSignIn(context);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Sign in succesful'),
                    ),
                  );
                  setState(() {
                    isSignedIn = true;
                  });
                } catch (e) {
                  print(e);
                }
              },
            ),
            ListTile(
              leading: Icon(FontAwesome.universal_access),
              title: Text(
                'Step two',
              ),
              subtitle: Text('Allow bookie manage your google books'),
              trailing: accessGranted
                  ? Icon(Icons.check, color: Colors.green)
                  : Icon(Icons.cancel, color: Colors.red),
              onTap: () async {
                try {
                  GetToken.token();
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isUserSignedIn();
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
              accessGranted ? recommended() : recommendedNull(context),
            ],
          ),
        ),
      ),
    );
  }
}
