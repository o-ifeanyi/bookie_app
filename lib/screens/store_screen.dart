import 'package:bookie/models/error_handling.dart';
import 'package:bookie/models/get_books.dart';
import 'package:bookie/models/provider.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:bookie/screens/view_more.dart';
import 'package:bookie/components/list_builder.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StoreScreen> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  GetBooks getBooks = GetBooks();

  final Map<String, String> bookTags = {
    'Romance': 'Feel the passion',
    'Drama': 'Engross yourself',
    'History': 'Revisit history',
    'Action': 'Live the action',
    'Art': 'Experience art',
    'Mystery': 'So mysterious',
    'Horror': 'Shivers',
    'Fantasy': 'Wish on',
  };
  num pageListNumber = 0;
  bool pageIsEmpty = true;

  //loops through the bookTag list
  //perfoms an API call for each book tag using the "subject" parameter
  //adds a widget that displays this data to the provider class so as to update the screen
  Future<void> buildPageList(context, bool isEmpty) async {
    int listLenght = 0;
    setState(() {
      pageIsEmpty = isEmpty;
      loadingPage = Container(
        child: Center(
          child: GlowingProgressIndicator(
            child: Icon(Icons.book, size: 50, color: Color(0xFF2296F3),),
          ),
        ),
      );
    });
    for (String tag in bookTags.keys) {
      var bookData;
      try {
        bookData = await getBooks.getTagBooks(tag);
        listLenght = 0;
        bookData['items'].forEach((book) => listLenght++);
        setState(() {
          pageIsEmpty = false;
        });
        Provider.of<ProviderClass>(context, listen: false).addToPage(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      bookTags[tag],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kaushan Script',
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                        ),
                        //pass the tag and data gotten for that tag to view_more page
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewMore(
                                tag: tag,
                                bookData: bookData,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
              Container(
                height: 180,
                padding: EdgeInsets.only(left: 12),
                child: ListBuilder(data: bookData, listLenght: listLenght),
              ),
            ],
          ),
        );
        pageListNumber++;
      } catch (SocketException) {
        pageListNumber = 0;
        //look for a better way to stop snacbar from showing up everytime
        if (tag == 'Romance') {
          setState(() {
            loadingPage = Container(
              child: ErrorPage(() {
                buildPageList(context, true);
              }),
            );
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    buildPageList(context, true);
  }

  Future<void> refresh() {
    Provider.of<ProviderClass>(context, listen: false).pageListWidget.clear();
    pageListNumber = 0;
    return buildPageList(context, false);
  }

  var loadingPage = Container(
    child: Center(
      child: GlowingProgressIndicator(
        child: Icon(Icons.book, size: 50, color: Color(0xFF2296F3),),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Consumer<ProviderClass>(
              builder: (context, pageList, child) {
                return Expanded(
                  child: pageIsEmpty
                      ? loadingPage
                      : LiquidPullToRefresh(
                          onRefresh: () => refresh(),
                          showChildOpacityTransition: false,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: pageListNumber,
                            itemBuilder: (contex, index) {
                              return pageList.pageListWidget[index];
                            },
                          ),
                        ),
                );
              },
            ),
          ]),
    );
  }
}
