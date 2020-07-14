import 'package:bookie/models/download_helper.dart';
import 'package:bookie/models/favourites_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderClass extends ChangeNotifier {
  var dlDB = DownloadsDB();
  var fvDB = FavoriteDB();
  List<Widget> pageListWidget = [];
  bool downloaded = false;
  bool isFavourite = false;
  var bookToRead;
  var currentlyReading;
  List allBooks = [];
  List favourites = [];

  void addToPage(Widget widget) async {
    pageListWidget.add(widget);
    notifyListeners();
  }

  Future<void> addToDataBase(Map item) async {
    await dlDB.add(item);
    notifyListeners();
  }

  Future<void> addToFavourites(Map item) async {
    await fvDB.add(item);
    favourites.clear();
    await getFavouriteBooks();
    notifyListeners();
  }

  Future<void> removeFavourite(String id) async {
    List favouriteBooks = await fvDB.check({'id': id});
    if (favouriteBooks.isNotEmpty) {
      await fvDB.remove(favouriteBooks.first);
      isFavourite = false;
    }
    favourites.clear();
    await getFavouriteBooks();
    notifyListeners();
  }

  Future<void> getFavouriteBooks() async {
    List favouriteBooks = await fvDB.listAll();
    if (favouriteBooks.isNotEmpty) {
      favourites = favouriteBooks;
    }
    notifyListeners();
  }

  Future<void> checkFavourites({String id}) async {
    List favouriteBooks = await fvDB.check({'id': id});
    if (favouriteBooks.isNotEmpty) {
      isFavourite = true;
    } else {
      isFavourite = false;
    }
    notifyListeners();
  }

  Future<void> checkDownload({String id}) async {
    List downloadedBooks = await dlDB.check({'id': id});
    if (downloadedBooks.isNotEmpty) {
      bookToRead = downloadedBooks.first;
      downloaded = true;
    } else {
      downloaded = false;
    }
    notifyListeners();
  }

  Future<void> getDownloadedBooks() async {
    List downloadedBooks = await dlDB.listAll();
    if (downloadedBooks.isNotEmpty) {
      allBooks = downloadedBooks;
    }
    notifyListeners();
  }

  Future<void> lastOpenedBook(var id) async {
    List downloadedBooks = await dlDB.listAll();
    if (downloadedBooks.isNotEmpty) {
      for (var book in downloadedBooks) {
        var bookId = book['id'];
        if (bookId == id) {
          currentlyReading = book;
        }
      }
    }
    notifyListeners();
  }
}
