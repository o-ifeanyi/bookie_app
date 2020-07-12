import 'package:bookie/models/download_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderClass extends ChangeNotifier {
  List<Widget> pageListWidget = [];
  var dlDB = DownloadsDB();
  bool downloaded = false;
  var bookToRead;

  void addToPage(Widget widget) {
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
      bookToRead = downloadedBooks[0];
      downloaded = true;
    } else {
      downloaded = false;
    }
    notifyListeners();
  }
}