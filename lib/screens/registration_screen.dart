import 'package:bookie/constants.dart';
import 'package:bookie/models/error_handling.dart';
import 'package:bookie/screens/home.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:bookie/components/rounded_button.dart';
import 'package:bookie/models/signin_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  void goTo(String option) {
    setState(() {
      screen = option;
      email = "";
      password = "";
      loginEmailController.clear();
      loginPasswordController.clear();
      signUpEmailController.clear();
      signUpPasswordController.clear();
    });
  }

  final _auth = FirebaseAuth.instance;
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  String screen = 'login';
  String email;
  String password;
  SignInSignUp signInSignUp = SignInSignUp();
  bool loading = false;

  void isLoggedIn() async {
    var user = await _auth.currentUser();
    if (user != null) {
      Navigator.pushNamed(context, MyHome.id);
    }
  }

  @override
  void initState() {
    super.initState();
    isLoggedIn();
  }

  void showLoader() {
    setState(() {
      loading = true;
    });
  }

  void dismissLoader() {
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (screen == 'login') {
      return LoadingOverlay(
        opacity: 0.1,
        isLoading: loading,
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.fromLTRB(30, 100, 30, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        goTo('login');
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: kBlueAccent),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        goTo('sign up');
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kBlueAccent),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: loginEmailController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: kLightBlack,
                    ),
                    labelText: 'Email',
                  ),
                  onChanged: (newValue) {
                    email = newValue;
                  },
                ),
                TextField(
                  controller: loginPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: kLightBlack,
                    ),
                    labelText: 'Password',
                  ),
                  onChanged: (newValue) {
                    password = newValue;
                  },
                ),
                RoundedButton(
                  onPressed: () {
                    showLoader();
                    try {
                      signInSignUp.handleEmailPasswordLogin(
                          context, email, password);
                    } catch (SocketException) {
                      ErrorHandling.handleSocketException(context);
                    } finally {
                      dismissLoader();
                    }
                  },
                  colour: kBlueAccent,
                  label: 'Login',
                ),
                Text('or login with'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: kBlueAccent,
                        radius: 20.0,
                        child: Icon(
                          FontAwesome.google,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        showLoader();
                        try {
                          signInSignUp.handleGoogleSignIn(context);
                        } catch (SocketException) {
                          ErrorHandling.handleSocketException(context);
                        } finally {
                          dismissLoader();
                        }
                      },
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: kBlueAccent,
                      radius: 20.0,
                      child: Icon(
                        FontAwesome.facebook,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: kBlueAccent,
                      radius: 20.0,
                      child: Icon(
                        FontAwesome.twitter,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Dont have an account?'),
                    SizedBox(width: 10),
                    Text('Sign Up'),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return LoadingOverlay(
        opacity: 0.1,
        isLoading: loading,
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.fromLTRB(30, 100, 30, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        goTo('login');
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kBlueAccent),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        goTo('sign up');
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: kBlueAccent),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: signUpEmailController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: kLightBlack,
                    ),
                    labelText: 'Email',
                  ),
                  onChanged: (newValue) {
                    email = newValue;
                  },
                ),
                TextField(
                  controller: signUpPasswordController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: kLightBlack,
                    ),
                    labelText: 'Password',
                  ),
                  onChanged: (newValue) {
                    password = newValue;
                  },
                ),
                TextField(
                  controller: signUpPasswordController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.refresh,
                      color: kLightBlack,
                    ),
                    labelText: 'Confirm Password',
                  ),
                ),
                RoundedButton(
                  onPressed: () {
                    showLoader();
                    try {
                      signInSignUp.handleEmailPasswordSignUp(
                          context, email, password);
                    } catch (SocketException) {
                      ErrorHandling.handleSocketException(context);
                    } finally {
                      dismissLoader();
                    }
                  },
                  colour: kBlueAccent,
                  label: 'Sign Up',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Already have an account?'),
                    SizedBox(width: 10),
                    Text('Login'),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
