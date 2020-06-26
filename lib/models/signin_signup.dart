import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bookie/screens/home.dart';

class SignInSignUp {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void handleEmailPasswordLogin(
      BuildContext context, String email, String password) async {
    final user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (user != null) {
      Navigator.pushNamed(
        context,
        MyHome.id,
      );
    }
    print('log in successful');
  }

  void handleEmailPasswordSignUp(
      BuildContext context, String email, String password) async {
    final user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (user != null) {
      Navigator.pushNamed(
        context,
        MyHome.id,
      );
    }
    print('sign up successful');
  }

  void handleGoogleSignIn(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleUserAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleUserAuth.accessToken,
      idToken: googleUserAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    if (user != null) {
      Navigator.pushNamed(
        context,
        MyHome.id,
      );
    }
    print("signed in to google as" + user.displayName);
  }
}
