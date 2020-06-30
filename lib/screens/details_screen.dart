import 'package:bookie/components/book_card.dart';
import 'package:bookie/screens/book_reader.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:bookie/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DetailsScreen extends StatefulWidget {
  static String id = 'detailScreen';
  final bookToDisplay;

  DetailsScreen({@required this.bookToDisplay});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
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
  bool _dialVisible = true;

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

  void initState() {
    super.initState();
    displayResult(widget.bookToDisplay);
    category = getCategory(categories);
    scrollController = ScrollController()
      ..addListener(() {
        setDailVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
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
      backgroundColor: Color(0xFFFAFAFA),
      body: Container(
        child: ListView(
          controller: scrollController,
          children: <Widget>[
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[],
            // ),
            SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 10),
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
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Kaushan Script',
                          ),
                        ),
                        SizedBox(height: 5),
                        getRating(rating),
                        SizedBox(height: 5),
                        Text(
                          'By ${author[0]}\nPublish Date: $publishDate\nPublisher: $publisher\nCategory: $category\nPages: $pageCount',
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
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Kaushan Script',
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                description,
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.fade,
                style: TextStyle(fontFamily: 'Source Sans Pro', fontSize: 16),
              ),
            ),
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
