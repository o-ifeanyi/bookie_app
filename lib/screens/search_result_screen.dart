import 'package:bookie/constants.dart';
import 'package:flutter/material.dart';
import 'package:bookie/components/book_card.dart';
import 'package:bookie/screens/details_screen.dart';

class SearchResult extends StatelessWidget {
  static String id = 'searchResultScreen';
  final searchResult;
  final searchQuery;

  SearchResult({@required this.searchResult, this.searchQuery});

  final imagePlaceHolder =
      'https://lh3.googleusercontent.com/proxy/u8TYJjSEp6IjX6HF2BqR2PmM68Zf6uG-l_DamX5vNfO-euliRz4vfeIJvHlp6CZ1B0EGCW3SXBTEyLjdu2poFM16m0Dr1rMt';
  static String imageLink;
  static String author;
  static String title;
  static String publishDate;
  static String description;

  void displayResult(data, index) {
    var searchResultInfo = searchResult['items'][index]['volumeInfo'];
    try {
      imageLink = searchResultInfo['imageLinks']['smallThumbnail'];
    } catch (e) {
      if (imageLink == null) {
        imageLink = imagePlaceHolder;
      }
      print(e);
    }
    author = searchResultInfo['authors'][0] ?? 'Unavailable';
    title = searchResultInfo['title'] ?? 'Unavailable';
    publishDate = searchResultInfo['publishedDate'] ?? 'Unavailable';
    description = searchResultInfo['description'] ?? 'Unavailable';
  }

  @override
  Widget build(BuildContext context) {
    var noResultPage = Container(
      height: 300,
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 80,
            child: Divider(
              color: kBlueAccent,
              height: 25.0,
              thickness: 3.0,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
              'No result for\n"$searchQuery"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Source Sans Pro',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: kLightBlack,
              ),
            ),
        ],
      ),
    );
    print('search result is $searchResult');
    return searchResult['totalItems'] == 0
        ? noResultPage
        : Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              margin: EdgeInsets.only(top: 120, left: 15, right: 15),
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  Text(
                    'Showing result for\n"$searchQuery"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Kaushan Script',
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        try {
                          displayResult(searchResult, index);
                        } catch (e) {
                          print('error with search result: $e');
                        }
                        return GestureDetector(
                          onTap: () {
                            var displayBook = searchResult['items'][index];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  bookToDisplay: displayBook,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 6.0,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            color: Color(0xFFFAFAFA),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Hero(
                                  tag: 'bookImage',
                                  child: BookCard(
                                    imgHeight: 180,
                                    imgWidth: 130,
                                    imageLink: imageLink,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        author,
                                        style: kSearchResultTextStyle,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Kaushan Script',
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        publishDate,
                                        style: kSearchResultTextStyle,
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        height: 60,
                                        child: Text(
                                          description,
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'Source Sans Pro',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      // itemCount: lenght,
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: kBlueAccent,
              child: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
  }
}
