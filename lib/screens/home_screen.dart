import 'package:bookie/components/book_card.dart';
import 'package:bookie/components/rounded_button.dart';
import 'package:bookie/constants.dart';
import 'package:bookie/models/provider.dart';
import 'package:bookie/screens/book_reader.dart';
import 'package:bookie/screens/details_screen.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List cardKeys = [];
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void updateScreen() async {
    await Provider.of<ProviderClass>(context, listen: false)
        .getCurrentlyReading();
    await Provider.of<ProviderClass>(context, listen: false)
        .getDownloadedBooks();
    await Provider.of<ProviderClass>(context, listen: false)
        .getFavouriteBooks();
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
    updateScreen();
    return Future.delayed(duration);
  }

  @override
  void initState() {
    // updateScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateScreen();
    return Consumer<ProviderClass>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Scaffold(
            body: LiquidPullToRefresh(
              showChildOpacityTransition: false,
              onRefresh: () => refresh(),
              child: ListView(
                padding: EdgeInsets.only(left: 15, top: 10),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Continue reading',
                      style: kActiveStyle,
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
                                      ['volumeInfo']['imageLinks']
                                  ['smallThumbnail'],
                              onPressed: () {
                                var book =
                                    provider.currentlyReading['bookInfo'];
                                openDetails(book);
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  RoundedButton(
                                    colour: Theme.of(context).accentColor,
                                      onPressed: () {
                                        var id =
                                            provider.currentlyReading['id'];
                                        var path =
                                            provider.currentlyReading['path'];
                                        openBook(path, id);
                                      },
                                      label: 'Read Now')
                                ],
                              ),
                            ),
                          ],
                        ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Downloaded',
                      style: kActiveStyle,
                    ),
                  ),
                  provider.allBooks.isEmpty
                      ? emptyState("images/no_downloads.png")
                      : Container(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.allBooks.length,
                            itemBuilder: (context, index) {
                              // cardKeys[index] = Key('cardKey$index');
                              var bookInfo =
                                  provider.allBooks[index]['bookInfo'];
                              var id = provider.allBooks[index]['id'];
                              return FlipCard(
                                // key: cardKeys[index],
                                front: BookCard(
                                  imgHeight: 240,
                                  imgWidth: 170,
                                  imageLink: bookInfo['volumeInfo']
                                      ['imageLinks']['smallThumbnail'],
                                ),
                                back: Card(
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Container(
                                    height: 240,
                                    width: 170,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            openDetails(bookInfo);
                                          },
                                          child: Text('View Info'),
                                        ),
                                        FlatButton(
                                            onPressed: () {
                                              var path = provider
                                                  .allBooks[index]['path'];
                                              openBook(path, id);
                                            },
                                            child: Text('Read Now')),
                                        FlatButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text(
                                                      'Delete ${bookInfo['volumeInfo']['title']}?'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () async {
                                                        await provider
                                                            .removeDownload(id);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('yes'),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        // cardKeys[index].currentState.toggleCard();
                                                      },
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Favourites',
                      style: kActiveStyle,
                    ),
                  ),
                  provider.favourites.isEmpty
                      ? emptyState("images/no_favourites.png")
                      : Container(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.favourites.length,
                            itemBuilder: (context, index) {
                              var bookInfo =
                                  provider.favourites[index]['bookInfo'];
                              var id = provider.favourites[index]['id'];
                              return FlipCard(
                                front: BookCard(
                                  imgHeight: 240,
                                  imgWidth: 170,
                                  imageLink: bookInfo['volumeInfo']
                                      ['imageLinks']['smallThumbnail'],
                                ),
                                back: Card(
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Container(
                                    height: 240,
                                    width: 170,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            openDetails(bookInfo);
                                          },
                                          child: Text('View Info'),
                                        ),
                                        FlatButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text(
                                                      'Remove "${bookInfo['volumeInfo']['title']}" from favourites?'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () async {
                                                        await provider
                                                            .removeFavourite(
                                                                id);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('yes'),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('No'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Text('Remove'))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
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
              color: Theme.of(context).accentColor,
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
                Text('Nothing is beign read'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
