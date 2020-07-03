import 'package:flutter/material.dart';
import 'package:bookie/constants.dart';
import 'package:bookie/models/get_books.dart';
import 'package:bookie/screens/details_screen.dart';
import 'package:bookie/components/book_card.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:progress_indicators/progress_indicators.dart';

class SearchScreen extends StatefulWidget {
  static String id = 'searchScreen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  GetBooks getBooks = GetBooks();
  bool loading = false;
  String dropdownValue = 'title';
  String _selection = 'title';
  String searchInput;
  String displayText = 'Nothing to display';
  final searchFeildController = TextEditingController();
  var booksData;
  final imagePlaceHolder =
      'https://lh3.googleusercontent.com/proxy/u8TYJjSEp6IjX6HF2BqR2PmM68Zf6uG-l_DamX5vNfO-euliRz4vfeIJvHlp6CZ1B0EGCW3SXBTEyLjdu2poFM16m0Dr1rMt';
  static String imageLink;
  static String author;
  static String title;
  static String publishDate;
  static String description;
  static int listLenght = 0;

  void getBooksByTitle(title) async {
    booksData = await getBooks.getTitleBooks(title);
    getLenght(booksData);
  }

  void getBooksByAuthor(author) async {
    booksData = await getBooks.getAuthorBooks(author);
    getLenght(booksData);
  }

  void getBooksByPublisher(publisher) async {
    booksData = await getBooks.getPublisherBooks(publisher);
    getLenght(booksData);
  }

  void getLenght(data) {
    try {
      data['items'].forEach((book) => listLenght++);
    } catch (e) {
      booksData = null;
      displayText = 'No result for\n"$searchInput"';
      debugPrint(e.toString());
    } finally {
      searchFeildController.clear();
      dismissLoader();
    }
  }

  void displayResult(data, index) {
    var searchResultInfo = booksData['items'][index]['volumeInfo'];
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

  void showLoader() {
    loading = true;
    setState(() {});
  }

  void dismissLoader() {
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: loading,
        opacity: 0.1,
        progressIndicator: GlowingProgressIndicator(
          child: Icon(
            Icons.book,
            color: kBlueAccent,
            size: 50,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: kLightBlack,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: kLightBlack,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: TextField(
                            controller: searchFeildController,
                            onChanged: (value) {
                              searchInput = value;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: PopupMenuButton<String>(
                                onSelected: (String newValue) {
                                  setState(() {
                                    _selection = newValue;
                                  });
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'title',
                                    child: Text('Search Title'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'author',
                                    child: Text('Search Author'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'publ',
                                    child: Text('Search Publisher'),
                                  ),
                                ],
                              ),
                              hintText: 'Search by title or author',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: kBlueAccent,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              displayText = '';
                            });
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (_selection == 'title' && searchInput != null) {
                              showLoader();
                              getBooksByTitle(searchInput);
                            } else if (_selection == 'author' &&
                                searchInput != null) {
                              showLoader();
                              getBooksByAuthor(searchInput);
                            } else if (_selection == 'publ' &&
                                searchInput != null) {
                              showLoader();
                              getBooksByPublisher(searchInput);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                booksData == null
                    ? Expanded(
                        child: Center(
                          child: Text(
                            displayText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Kaushan Script',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: kLightBlack,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: listLenght,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            try {
                              displayResult(booksData, index);
                            } catch (e) {
                              print('error with search result: $e');
                            }
                            return GestureDetector(
                              onTap: () {
                                var displayBook = booksData['items'][index];
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    BookCard(
                                      imgHeight: 180,
                                      imgWidth: 130,
                                      imageLink: imageLink,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
        ),
      ),
    );
  }
}
