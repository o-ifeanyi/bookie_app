import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;

class GetToken {
// App specific variables
static final googleClientId =
    '140447676311-nvsi4mlaoo2btfop26gkg8ck82ajv8m2.apps.googleusercontent.com';
static final callbackUrlScheme =
    'com.googleusercontent.apps.140447676311-nvsi4mlaoo2btfop26gkg8ck82ajv8m2:/oauth2redirect';

// Construct the url
static final url = Uri.https('accounts.google.com', '/o/oauth2/auth', {
  'response_type': 'code',
  'client_id': googleClientId,
  'redirect_uri': '$callbackUrlScheme',
  'scope': 'https://www.googleapis.com/auth/books',
});

static void token() async {
// Present the dialog to the user
  final result = await FlutterWebAuth.authenticate(
      url: url.toString(), callbackUrlScheme: callbackUrlScheme);
  print('result is $result');
// Extract code from resulting url
  final code = Uri.parse(result).queryParameters['code'];
  print('code is : $code');

// Use this code to get an access token
  final response =
      await http.post('https://oauth2.googleapis.com/token', body: {
    'client_id': googleClientId,
    'redirect_uri': '$callbackUrlScheme',
    'grant_type': 'authorization_code',
    'code': code,
  });
  print(response.body);
// Get the access token from the response
  final accessToken = jsonDecode(response.body)['access_token'] as String;
  print('token is $accessToken');
}
}