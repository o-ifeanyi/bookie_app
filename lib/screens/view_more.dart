import 'package:bookie/constants.dart';
import 'package:bookie/models/get_books.dart';
import 'package:bookie/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:bookie/components/grid_builder.dart';

class ViewMore extends StatefulWidget {
  final String tag;
  final bookData;
  ViewMore({this.bookData, this.tag});
  @override
  _ViewMoreState createState() => _ViewMoreState();
}

class _ViewMoreState extends State<ViewMore> {
  @override
   void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var newBooksData;
  var freeBooksData;
  num newGridLenght = 0;
  num freeGridLenght = 0;
  String displayText = '';

  void getFreeBooks(String tag) async {
    try {
      freeBooksData = await GetBooks().getFreeBooks(tag);
      print(freeBooksData);
      setState(() {});
      if (freeBooksData['items'] != null) {
        freeBooksData['items'].forEach((book) => freeGridLenght++);
      } else {
        setState(() {
          displayText = 'No free books for ${widget.tag} category';
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getFreeBooks(widget.tag);
    newBooksData = widget.bookData;
    widget.bookData['items'].forEach((book) => newGridLenght++);
  }

  @override
  void dispose() {
    super.dispose();
    freeBooksData = null;
    displayText = '';
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pageWidgets = [
      Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: GridBuilder(data: newBooksData, lenght: newGridLenght,),
      ),
      Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: freeBooksData == null
            ? Center(
                child: GlowingProgressIndicator(
                  child: Icon(Icons.book, color: kBlueAccent, size: 50),
                ),
              )
            : Container(
                child: displayText == ''
                    ? GridBuilder(data: freeBooksData, lenght: freeGridLenght,)
                    : Center(
                        child: Text(displayText),
                      )),
      ),
    ];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.tag),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    SearchScreen.id,
                  );
                })
          ],
          bottom: TabBar(tabs: [
            Text(
              'New',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                fontFamily: 'Kaushan Script',
              ),
            ),
            Text(
              'Free',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                fontFamily: 'Kaushan Script',
              ),
            ),
          ]),
        ),
        body: TabBarView(children: pageWidgets),
      ),
    );
  }
}


