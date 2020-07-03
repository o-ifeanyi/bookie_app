import 'package:bookie/components/book_card.dart';
import 'package:bookie/components/list_builder.dart';
import 'package:bookie/models/get_books.dart';
import 'package:bookie/screens/book_reader.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:bookie/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_indicators/progress_indicators.dart';

class DetailsScreen extends StatefulWidget {
  static String id = 'detailScreen';
  final bookToDisplay;

  DetailsScreen({@required this.bookToDisplay});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
   void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }
  final imagePlaceHolder =
      'https://lh3.googleusercontent.com/proxy/u8TYJjSEp6IjX6HF2BqR2PmM68Zf6uG-l_DamX5vNfO-euliRz4vfeIJvHlp6CZ1B0EGCW3SXBTEyLjdu2poFM16m0Dr1rMt';
  String imageLink;
  var author; //some come as single strings and not list
  String title;
  String publishDate;
  String publisher;
  String description;
  var categories;
  var pageCount;
  String category;
  num rating;
  String downloadLink;
  ScrollController scrollController;
  int descriptonMaxLines = 10;
  bool _dialVisible = true;
  dynamic moreFromAuthorData;
  int listLenght = 0;
  String seeMore = 'View more';

  void getMoreData() async {
    try {
      var moreAuthor = author;
      moreFromAuthorData = await GetBooks().getAuthorBooks(moreAuthor);
      print(moreFromAuthorData);
      setState(() {});
      if (moreFromAuthorData['items'] != null) {
        moreFromAuthorData['items'].forEach((book) => listLenght++);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void displayResult(data) {
    var displayInfo = data['volumeInfo'];
    try {
      imageLink = displayInfo['imageLinks']['smallThumbnail'];
    } catch (e) {
      if (imageLink == null) {
        imageLink = imagePlaceHolder;
      }
      print(e);
    }
    author = displayInfo['authors'] ?? 'Unavailable';
    author = author.runtimeType == [].runtimeType ? author[0] : author;
    title = displayInfo['title'] ?? 'Unavailable';
    publishDate = displayInfo['publishedDate'] ?? 'Unavailable';
    publisher = displayInfo['publisher'] ?? 'Unavailable';
    description = displayInfo['description'] ?? 'Unavailable';
    categories = displayInfo['categories'] ?? 'Unavailable';
    pageCount = displayInfo['pageCount'] ?? 'Unavailable';
    rating = displayInfo['averageRating'];
    downloadLink = data['accessInfo']['pdf']['downloadLink'];
  }

  String getCategory(var input) {
    String output = '';
    if (input == null) {
      return 'Unavailable';
    } else if (input.runtimeType == String) {
      return input;
    } else {
      input.forEach((element) => output += '| $element');
      return output;
    }
  }

  Widget getRating(num number) {
    if (number == null) {
      return Text(
        'No Rating',
      );
    } else {
      number = number.toInt();
      List<Icon> ratingCount = [];
      for (int i = 0; i < 5; i++) {
        if (i < number) {
          ratingCount.add(Icon(
            Icons.star,
            color: Colors.orange,
          ));
        } else {
          ratingCount.add(Icon(Icons.star_border));
        }
      }
      return Row(
        children: ratingCount,
      );
    }
  }

  void setDailVisible(bool value) {
    setState(() {
      _dialVisible = value;
    });
  }

  @override
  void initState() {
    super.initState();

    displayResult(widget.bookToDisplay);

    category = getCategory(categories);
    scrollController = ScrollController()
      ..addListener(() {
        setDailVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
    getMoreData();
  }

  @override
  void dispose() {
    super.dispose();
    moreFromAuthorData = null;
  }

  IconData addBook = Icons.library_add;
  IconData like = Icons.favorite_border;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          iconSize: 30,
        ),
        actions: <Widget>[
          Icon(
            Icons.more_horiz,
            size: 30,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: ListView(
          controller: scrollController,
          children: <Widget>[
            SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Hero(
                    tag: 'bookImage',
                    child: BookCard(
                      imgHeight: 260,
                      imgWidth: 180,
                      imageLink: imageLink,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 260,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: kCursiveHeading,
                        ),
                        SizedBox(height: 5),
                        getRating(rating),
                        SizedBox(height: 5),
                        Text(
                          'By $author\nPublish Date: $publishDate\nPublisher: $publisher\nCategory: $category\nPages: $pageCount',
                          overflow: TextOverflow.fade,
                          style: kSearchResultTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 5),
            Text(
              'About This Book',
              textAlign: TextAlign.center,
              style: kCursiveHeading,
            ),
            SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              maxLines: descriptonMaxLines,
              softWrap: true,
              overflow: TextOverflow.fade,
              style: TextStyle(fontFamily: 'Source Sans Pro', fontSize: 16),
            ),
            SizedBox(height: 5),
            GestureDetector(
              child: Text(
                seeMore,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: kBlueAccent,
                ),
              ),
              onTap: () {
                setState(() {
                  seeMore == 'View more'
                      ? seeMore = 'View less'
                      : seeMore = 'View more';
                  descriptonMaxLines == 10
                      ? descriptonMaxLines = null
                      : descriptonMaxLines = 10;
                });
              },
            ),
            SizedBox(height: 5),
            Text(
              'More from the author',
              textAlign: TextAlign.start,
              style: kCursiveHeading,
            ),
            SizedBox(height: 5),
            Container(
                height: 180,
                child: moreFromAuthorData == null
                    ? Center(
                        child: GlowingProgressIndicator(
                          child: Icon(Icons.book, color: kBlueAccent, size: 30),
                        ),
                      )
                    : ListBuilder(
                        data: moreFromAuthorData, listLenght: listLenght)),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        visible: _dialVisible,
        overlayOpacity: 0.5,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(FlutterIcons.book_reader_faw5s),
            label: downloadLink == null ? 'Unavailable' : 'Available',
            labelStyle: TextStyle(color: Colors.white),
            labelBackgroundColor:
                downloadLink == null ? Colors.red : Colors.green,
            onTap: () {
              if (downloadLink != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookReader(
                      url: downloadLink,
                      title: title,
                    ),
                  ),
                );
              }
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.library_add),
          ),
          SpeedDialChild(
            child: Icon(Icons.favorite),
          ),
        ],
      ),
    );
  }
}
