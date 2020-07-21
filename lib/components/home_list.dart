import 'package:bookie/components/book_card.dart';
import 'package:bookie/screens/book_reader.dart';
import 'package:bookie/screens/details_screen.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class BuildHomeList extends StatelessWidget {
  final provider;
  final bool isDownload;

  BuildHomeList({this.isDownload, this.provider});
  @override
  Widget build(BuildContext context) {
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

    return Container(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:
            isDownload ? provider.allBooks.length : provider.favourites.length,
        itemBuilder: (context, index) {
          // cardKeys[index] = Key('cardKey$index');
          var bookInfo = isDownload
              ? provider.allBooks[index]['bookInfo']
              : provider.favourites[index]['bookInfo'];
          var id = isDownload
              ? provider.allBooks[index]['id']
              : provider.favourites[index]['id'];
          return FlipCard(
            // key: cardKeys[index],
            front: BookCard(
              imgHeight: 240,
              imgWidth: 170,
              imageLink: bookInfo['volumeInfo']['imageLinks']['smallThumbnail'],
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        openDetails(bookInfo);
                      },
                      child: Text('View Info'),
                    ),
                    isDownload
                        ? FlatButton(
                            onPressed: () {
                              var path = provider.allBooks[index]['path'];
                              openBook(path, id);
                            },
                            child: Text('Read Now'))
                        : SizedBox.shrink(),
                    FlatButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(isDownload
                                  ? 'Delete "${bookInfo['volumeInfo']['title']}" from downloads?'
                                  : 'Remove "${bookInfo['volumeInfo']['title']}" from favourites?'),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () async {
                                    if (isDownload) {
                                      await provider.removeDownload(id);
                                    }
                                    if (!isDownload) {
                                      await provider.removeFavourite(id);
                                    }
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
                        child: Text(isDownload ? 'Delete' : 'Remove'))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
