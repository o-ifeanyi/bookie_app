import 'package:bookie/models/error_handling.dart';
import 'package:bookie/models/get_books.dart';
import 'package:bookie/models/provider.dart';
import 'package:bookie/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookie/constants.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:bookie/screens/view_more.dart';
import 'package:bookie/screens/search_screen.dart';
import 'package:bookie/components/list_builder.dart';

import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StoreScreen> {
  @override
   void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }
  GetBooks getBooks = GetBooks();
  final Map<String, String> bookTags = {
    'Romance': 'Feel the passion',
    'Drama': 'Engross yourself',
    'Fiction': 'Imagine!',
    // 'Classic': 'Classic tales',
    // 'History': 'Revisit history',
    // 'Anime': 'Animation',
    // 'Action': 'Live the action',
    // 'Art',
    // 'Encyclopedia',
    // 'Mystery',
    // 'Poetry',
    // 'Fantasy',
  };
  num pageListNumber = 0;
  bool loading = false;
  bool pageIsEmpty = true;
      
  //loops through the bookTag list
  //perfoms an API call for each book tag using the "subject" parameter
  //adds a widget that displays this data to the provider class so as to update the screen
  void buildPageList(context) async {
    setState(() {
      pageIsEmpty = true;
      loadingPage = Container(
        child: Center(
          child: GlowingProgressIndicator(
            child: Icon(Icons.book, color: kBlueAccent, size: 50),
          ),
        ),
      );
    });
    for (String tag in bookTags.keys) {
      var bookData;
      try {
        bookData = await getBooks.getTagBooks(tag);
        setState(() {
          pageIsEmpty = false;
        });
      } catch (SocketException) {
        setState(() {
          ErrorHandling.handleSocketException(context);
          loadingPage = Container(
            child: ErrorPage(() {
              buildPageList(context);
            }),
          );
        });
      }

      print('got books for $tag');
      int listLenght = 0;
      bookData['items'].forEach((book) => listLenght++);
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
                      color: kLightBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kaushan Script',
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: kLightBlack,
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
    }
  }

  @override
  void initState() {
    super.initState();
    buildPageList(context);
  }

  void showLoader() {
    loading = true;
    setState(() {});
  }

  void dismissLoader() {
    loading = false;
    setState(() {});
  }

  var loadingPage = Container(
    child: Center(
      child: GlowingProgressIndicator(
        child: Icon(Icons.book, color: kBlueAccent, size: 50),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      progressIndicator: CircularProgressIndicator(
        strokeWidth: 2.0,
        backgroundColor: Colors.transparent,
      ),
      color: Colors.black,
      opacity: 0.5,
      isLoading: loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Store',
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
              ),
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
            )
          ],
        ),
        body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Consumer<ProviderClass>(
                builder: (context, pageList, child) {
                  return Expanded(
                    child: pageIsEmpty
                        ? loadingPage
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: pageListNumber,
                            itemBuilder: (contex, index) {
                              return pageList.pageListWidget[index];
                            },
                          ),
                  );
                },
              ),
            ]),
      ),
    );
  }
}


