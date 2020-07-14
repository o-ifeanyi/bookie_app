import 'package:bookie/components/book_card.dart';
import 'package:bookie/constants.dart';
import 'package:bookie/models/provider.dart';
import 'package:bookie/screens/book_reader.dart';
import 'package:bookie/screens/details_screen.dart';
import 'package:bookie/screens/search_screen.dart';
import 'package:bookie/screens/settings_screen.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void updateScreen() {
    // Provider.of<ProviderClass>(context, listen: false).lastOpenedBook();
    Provider.of<ProviderClass>(context, listen: false).getDownloadedBooks();
  }

  void openBook(var path, var id) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BookReader(
                id: id,
                bookPath: path,
              )),
    );
  }

  void openDetails(var book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(bookToDisplay: book),
      ),
    );
  }

  Future<void> refresh() {
    Duration duration = Duration(seconds: 1);
    setState(() {});
    return Future.delayed(duration);
  }

  @override
  void initState() {
    updateScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // currentlyReading();
    return Scaffold(
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
      body: Consumer<ProviderClass>(
        builder: (context, provider, child) {
          return LiquidPullToRefresh(
            showChildOpacityTransition: false,
            onRefresh: () => refresh(),
            child: ListView(
              padding: EdgeInsets.only(left: 15, top: 10),
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
                provider.currentlyReading == null
                    ? continueReadingNull(boxHeight: 240, boxWidth: 170)
                    : Row(
                        children: <Widget>[
                          BookCard(
                            imgHeight: 240,
                            imgWidth: 170,
                            imageLink: provider.currentlyReading['bookInfo']
                                ['volumeInfo']['imageLinks']['smallThumbnail'],
                            onPressed: () {
                              var book = provider.currentlyReading['bookInfo'];
                              openDetails(book);
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  provider.currentlyReading['bookInfo']
                                      ['volumeInfo']['authors'],
                                  style: kSearchResultTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  provider.currentlyReading['bookInfo']
                                      ['volumeInfo']['title'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Kaushan Script',
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  provider.currentlyReading['bookInfo']
                                      ['volumeInfo']['publishedDate'],
                                  style: kSearchResultTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  provider.currentlyReading['bookInfo']
                                      ['volumeInfo']['description'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: kSearchResultTextStyle,
                                ),
                                FlatButton(
                                    color: kBlueAccent,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      var id = provider.currentlyReading['id'];
                                      var path =
                                          provider.currentlyReading['path'];
                                      openBook(path, id);
                                    },
                                    child: Text(
                                      'Read Now',
                                      textAlign: TextAlign.start,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 5),
                Text(
                  'Downloaded',
                  style: kActiveStyle,
                ),
                provider.allBooks.isEmpty
                    ? emptyState("images/no_downloads.png")
                    : Container(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.allBooks.length,
                          itemBuilder: (context, index) {
                            var bookInfo = provider.allBooks[index]['bookInfo'];
                            return FlipCard(
                              front: BookCard(
                                imgHeight: 180,
                                imgWidth: 130,
                                imageLink: bookInfo['volumeInfo']['imageLinks']
                                    ['smallThumbnail'],
                              ),
                              back: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: Container(
                                  height: 180,
                                  width: 130,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          openDetails(bookInfo);
                                        },
                                        child: Text('View Info'),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            var id =
                                                provider.allBooks[index]['id'];
                                            var path = provider.allBooks[index]
                                                ['path'];
                                            openBook(path, id);
                                          },
                                          child: Text('Read Now')),
                                      GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                    'Delete ${bookInfo['volumeInfo']['title']}?'),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {},
                                                    child: Text('yes'),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () {},
                                                    child: Text('No'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text('Delete'))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                Text(
                  'Favourites',
                  style: kActiveStyle,
                ),
                provider.favourites.isEmpty
                    ? emptyState("images/no_favourites.png")
                    : Container(
                        child: Center(
                          child: Text('hi'),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget emptyState(String image) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
    );
  }

  Widget continueReadingNull({double boxHeight, double boxWidth}) {
    return Container(
      height: boxHeight,
      child: Row(
        children: <Widget>[
          Container(
            height: boxHeight,
            width: boxWidth,
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
}
