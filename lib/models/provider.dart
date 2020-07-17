import 'package:bookie/models/download_helper.dart';
import 'package:bookie/models/favourites_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderClass extends ChangeNotifier {

  ProviderClass(this._themeData);

  ThemeData _themeData;
  var dlDB = DownloadsDB();
  var fvDB = FavoriteDB();
  var crDB = CurrentlyReadingDB();
  List<Widget> pageListWidget = [];
  bool downloaded = false;
  bool isFavourite = false;
  var bookToRead;
  var currentlyReading;
  List allBooks = [];
  List favourites = [];

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }

  void addToPage(Widget widget) async {
    pageListWidget.add(widget);
    notifyListeners();
  }

  Future<void> addToDataBase(Map item) async {
    await dlDB.add(item);
    await getDownloadedBooks();
    notifyListeners();
  }

  Future<void> addToFavourites(String id, var bookInfo) async {
    await fvDB.add({
      'id': id,
      'bookInfo': bookInfo,
    });
    favourites.clear();
    await getFavouriteBooks();
    notifyListeners();
  }

  Future<void> removeFavourite(String id) async {
    await fvDB.remove({'id': id});
    isFavourite = false;
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

  Future<void> removeDownload(String id) async {
    await dlDB.remove({'id': id});
    if (currentlyReading['id'] == id) {
      await crDB.remove({});
      currentlyReading = null;
    }
    downloaded = false;
    allBooks.clear();
    await getDownloadedBooks();
    notifyListeners();
  }

  Future<void> lastOpenedBook(var id) async {
    List currentItem = await crDB.listAll();
    if (currentItem.isNotEmpty) {
      await crDB.remove({});
      await crDB.add({
        'currentlyReading': id,
      });
    } else {
      await crDB.add({
        'currentlyReading': id,
      });
    }
    await getCurrentlyReading();
    notifyListeners();
  }

  Future<void> getCurrentlyReading() async {
    List currentItem = await crDB.listAll();
    if (currentItem.isNotEmpty) {
      List result =
          await dlDB.check({'id': currentItem.first['currentlyReading']});
      currentlyReading = result.first;
    }
    notifyListeners();
  }
}
