import 'package:bookie/models/network_helper.dart';
import 'package:bookie/models/secrets.dart';

class GetBooks {
  static String _apiKey = Secrets().apiKey;
  static String volumesBaseURL = 'https://www.googleapis.com/books/v1/volumes';

  Map filtered(var data) {
    var filteredData = data;
    for (var book in filteredData['iems']) {
      var info = book['volumeInfo'];
      if (info['imageLinks']['smallThumbnail'] == null ||
          info['authors'] == null ||
          info['title'] == null ||
          info['description'] == null) {
        filteredData['items'].remove(book);
      } else {
        continue;
      }
    }
    return filteredData;
  }

  Future<dynamic> getTagBooks(String tag) async {
    String url =
        '$volumesBaseURL?q=subject:$tag&orderBy=newest&key=$_apiKey';
    NetWorkHelper netWorkHelper = NetWorkHelper(url);
    var newTagBooksData = await netWorkHelper.getData();
    return newTagBooksData;
  }

  Future<dynamic> getTitleBooks(String title) async {
    String url =
        '$volumesBaseURL?q=intitle:$title&orderBy=relevance&key=$_apiKey';
    NetWorkHelper netWorkHelper = NetWorkHelper(url);
    var newTitleBooksData = await netWorkHelper.getData();
    return newTitleBooksData;
  }

  Future<dynamic> getAuthorBooks(String author) async {
    String url =
        '$volumesBaseURL?q=inauthor:$author&orderBy=relevance&key=$_apiKey';
    NetWorkHelper netWorkHelper = NetWorkHelper(url);
    var newAuthorBooksData = await netWorkHelper.getData();
    return newAuthorBooksData;
  }

  Future<dynamic> getPublisherBooks(String publisher) async {
    String url =
        '$volumesBaseURL?q=inpublisher:$publisher&orderBy=newest&key=$_apiKey';
    NetWorkHelper netWorkHelper = NetWorkHelper(url);
    var newPublisherBooksData = await netWorkHelper.getData();
    return newPublisherBooksData;
  }
}
