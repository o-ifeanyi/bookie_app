import 'package:flutter/material.dart';
import 'package:bookie/constants.dart';
import 'package:bookie/models/get_books.dart';
import 'package:bookie/screens/details_screen.dart';
import 'package:bookie/components/book_card.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  GetBooks getBooks = GetBooks();
  bool loading = false;
  String dropdownValue = 'title';
  String _selection = 'title';
  String searchInput;
  final searchFeildController = TextEditingController();
  var booksData;
  static String imageLink;
  static String author;
  static String title;
  static String publishDate;
  static String description;
  static int listLenght = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: loading,
        opacity: 0.6,
        progressIndicator: SizedBox.shrink(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
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
                                icon: Icon(Icons.tune),
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
                              suffixIcon: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    searchFeildController.clear();
                                    setState(() {
                                      searchInput = null;
                                      booksData = null;
                                    });
                                  }),
                              hintText: 'Search by title or author',
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (_selection == 'title' && searchInput != null) {
                            showLoader();
                            getBooksByTitle(searchInput);
                            searchInput = null;
                            searchFeildController.clear();
                          } else if (_selection == 'author' &&
                              searchInput != null) {
                            showLoader();
                            getBooksByAuthor(searchInput);
                            searchInput = null;
                            searchFeildController.clear();
                          } else if (_selection == 'publ' &&
                              searchInput != null) {
                            showLoader();
                            getBooksByPublisher(searchInput);
                            searchInput = null;
                            searchFeildController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                booksData == null
                    ? Expanded(
                      child: Container(
                          child: Center(
                            child: Image(
                              image: AssetImage('images/no_search.png'),
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

  void snackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Network currently unavailable'),
      ),
    );
  }

  void getBooksByTitle(title) async {
    try {
      booksData = await getBooks.getTitleBooks(title);
      getLenght(booksData);
    } catch (SocketException) {
      snackBar();
    } finally {
      dismissLoader();
    }
  }

  void getBooksByAuthor(author) async {
    try {
      booksData = await getBooks.getAuthorBooks(author);
      getLenght(booksData);
    } catch (SocketException) {
      snackBar();
    } finally {
      dismissLoader();
    }
  }

  void getBooksByPublisher(publisher) async {
    try {
      booksData = await getBooks.getPublisherBooks(publisher);
      getLenght(booksData);
    } catch (SocketException) {
      snackBar();
    } finally {
      dismissLoader();
    }
  }

  void getLenght(data) {
    try {
      data['items'].forEach((book) => listLenght++);
    } catch (e) {
      booksData = null;
      debugPrint(e.toString());
    } finally {
      dismissLoader();
    }
  }

  void displayResult(data, index) {
    var searchResultInfo = booksData['items'][index]['volumeInfo'];
    try {
      imageLink = searchResultInfo['imageLinks']['smallThumbnail'];
    } catch (e) {
      debugPrint(e.toString());
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

}
