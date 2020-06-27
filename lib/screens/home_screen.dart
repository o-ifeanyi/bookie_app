import 'package:bookie/components/book_card.dart';
import 'package:bookie/models/error_handling.dart';
import 'package:bookie/models/get_books.dart';
import 'package:bookie/models/provider.dart';
import 'package:bookie/screens/search_result_screen.dart';
import 'package:bookie/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookie/constants.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:bookie/screens/details_screen.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  var titleBooksData;
  var authorBooksData;
  var publisherBooksData;
  var imagePlaceHolder =
      'https://lh3.googleusercontent.com/proxy/u8TYJjSEp6IjX6HF2BqR2PmM68Zf6uG-l_DamX5vNfO-euliRz4vfeIJvHlp6CZ1B0EGCW3SXBTEyLjdu2poFM16m0Dr1rMt';
  String dropdownValue = 'title';
  String searchInput;
  final searchFeildController = TextEditingController();

  void getBooksByTitle(title) async {
    titleBooksData = await getBooks.getTitleBooks(title);
    setState(() {
      dismissLoader();
      goToSearchResult(titleBooksData, title);
    });
  }

  void getBooksByAuthor(author) async {
    authorBooksData = await getBooks.getAuthorBooks(author);
    setState(() {
      dismissLoader();
      goToSearchResult(authorBooksData, author);
    });
  }

  void getBooksByPublisher(publisher) async {
    publisherBooksData = await getBooks.getPublisherBooks(publisher);
    setState(() {
      dismissLoader();
      goToSearchResult(publisherBooksData, publisher);
    });
  }

  void goToSearchResult(data, searchQuery) {
    if (data != null) {
      searchFeildController.clear();
      showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: (context),
        builder: (context) => SearchResult(
          searchResult: data,
          searchQuery: searchQuery,
        ),
      );
    }
  }

  void buildPageList() async {
    for (String tag in bookTags.keys) {
      var bookData;
      try {
        setState(() {
          loadingPage = Container(
            child: Center(
              child: GlowingProgressIndicator(
                child: Icon(Icons.book, color: kBlueAccent, size: 50),
              ),
            ),
          );
        });
        bookData = await getBooks.getTagBooks(tag);
      } catch (SocketException) {
        setState(() {
          ErrorHandling.handleSocketException(context);
          loadingPage = Container(
            child: ErrorPage(() {
              buildPageList();
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
                      onPressed: () {})
                ],
              ),
            ),
            Container(
              height: 180,
              padding: EdgeInsets.only(left: 12),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var imageLink;
                  try {
                    imageLink = bookData['items'][index]['volumeInfo']
                        ['imageLinks']['smallThumbnail'];
                  } catch (e) {
                    print('error with list image: $e');
                    if (imageLink == null) {
                      imageLink = imagePlaceHolder;
                    }
                  }

                  return BookCard(
                    imgHeight: 180,
                    imgWidth: 130,
                    imageLink: imageLink,
                    onPressed: () {
                      var displayBook = bookData['items'][index];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                            bookToDisplay: displayBook,
                          ),
                        ),
                      );
                    },
                  );
                },
                itemCount: listLenght,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ),
      );
      pageListNumber++;
    }
  }

  void initState() {
    super.initState();
    buildPageList();
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
      opacity: 0.0,
      isLoading: loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Home',
          ),
          actions: <Widget>[
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
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: searchFeildController,
                  onChanged: (value) {
                    searchInput = value;
                  },
                  decoration: kInputDecoration.copyWith(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: DropdownButton(
                        icon: Icon(Icons.unfold_more),
                        value: dropdownValue,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['title', 'author', 'publ']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (dropdownValue == 'title' && searchInput != null) {
                          showLoader();
                          getBooksByTitle(searchInput);
                        } else if (dropdownValue == 'author' &&
                            searchInput != null) {
                          showLoader();
                          getBooksByAuthor(searchInput);
                        } else if (dropdownValue == 'publ' &&
                            searchInput != null) {
                          showLoader();
                          getBooksByPublisher(searchInput);
                        }
                      },
                    ),
                    hintText: 'Search by title or author',
                  ),
                ),
              ),
              Consumer<ProviderClass>(
                builder: (context, pageList, child) {
                  return Expanded(
                    child: pageList.pageListWidget.isEmpty
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
