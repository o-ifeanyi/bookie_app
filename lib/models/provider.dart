import 'package:bookie/models/download_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderClass extends ChangeNotifier {
  List<Widget> pageListWidget = [];
  var dlDB = DownloadsDB();
  bool downloaded = false;
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
