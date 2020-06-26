import 'dart:convert';
import 'package:http/http.dart' as http;

class NetWorkHelper {

  final url;
  NetWorkHelper(this.url);
  
  Future<dynamic> getData() async {
    http.Response response = await http.get(url);
    if(response.statusCode == 200) {
        String data = response.body;
        return jsonDecode(data);
      } else {
        print('response not gotten');
        print(response.statusCode);
      }
  }
}