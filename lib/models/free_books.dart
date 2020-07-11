import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:xml2json/xml2json.dart';

class FreeBooksApi {
  static String baseURL = 'https://catalog.feedbooks.com';
  static String publicDomainURL = '$baseURL/publicdomain/browse';
  static Map urls = {
    'Action': '$publicDomainURL/top.atom?cat=FBFIC002000',
    'Mystery': '$publicDomainURL/top.atom?cat=FBFIC022000',
    'Romance': '$publicDomainURL/top.atom?cat=FBFIC027000',
    'Horror': '$publicDomainURL/top.atom?cat=FBFIC015000',
    'Fantasy': '$publicDomainURL/top.atom?cat=FBFIC009000',
    'History': '$publicDomainURL/top.atom?cat=FBFIC014000',
    'Art': '$publicDomainURL/top.atom?cat=FBFIC019000',
    'Drama': '$publicDomainURL/top.atom?cat=FBDRA000000',
  };

  static Future<dynamic> getCategory(String tag) async {
    String category = urls[tag];
    Dio dio = Dio();
    var res = await dio.get(category).catchError((e) {
      print(e);
    });
    var bookData;
    var rearranged = {};
    rearranged['items'] = List(50);
    int i = 0;
    if (res.statusCode == 200) {
      Xml2Json xml2json = new Xml2Json();
      xml2json.parse(res.data.toString());
      bookData = jsonDecode(xml2json.toGData());
    } else {
      throw ('Error ${res.statusCode}');
    }
    for (var book in bookData['feed']['entry']) {
      rearranged['items'][i] = {};
      rearranged['items'][i]['volumeInfo'] = {};
      rearranged['items'][i]['volumeInfo']['imageLinks'] = {};
      rearranged['items'][i]['accessInfo'] = {};
      rearranged['items'][i]['accessInfo']['epub'] = {};

      rearranged['items'][i]['volumeInfo']['title'] = book['title']['\$t'];
      rearranged['items'][i]['volumeInfo']['authors'] =
          book['author']['name']['\$t'];
      rearranged['items'][i]['volumeInfo']['publishedDate'] =
          book['published']['\$t'].split('T')[0];
      rearranged['items'][i]['volumeInfo']['publisher'] = book['dcterms\$publisher']['\$t'];
      rearranged['items'][i]['volumeInfo']['description'] =
          book['summary']['\$t'];
      rearranged['items'][i]['volumeInfo']['categories'] = book['category'][0]['label'];
      rearranged['items'][i]['volumeInfo']['imageLinks']['smallThumbnail'] =
          book['link'][1]['href'];
      rearranged['items'][i]['accessInfo']['epub']['downloadLink'] = book['link'][3]['href'];
      i++;
    }
    return rearranged;
  }
}
