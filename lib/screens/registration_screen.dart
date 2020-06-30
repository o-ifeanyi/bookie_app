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
  void clearTextFeilds() {
    setState(() {
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
  String email;
  String password;
  SignInSignUp signInSignUp = SignInSignUp();
  bool loading = false;

  void isLoggedIn() async {
    var user = await _auth.currentUser();
    if (user != null) {
      Navigator.pushNamed(
        context,
        MyHome.id,
      );
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

  Widget logInPage(context) {
    return LoadingOverlay(
      opacity: 0.1,
      isLoading: loading,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(30, 100, 30, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
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
                onPressed: () async {
                  showLoader();
                  try {
                    await signInSignUp.handleEmailPasswordLogin(
                        context, email, password);
                    clearTextFeilds();
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
                    onTap: () async {
                      showLoader();
                      try {
                        await signInSignUp.handleGoogleSignIn(context);
                        clearTextFeilds();
                        Navigator.pushNamed(context, MyHome.id);
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
                  SizedBox(width: 5),
                  Text(
                    'Sign Up',
                    style: TextStyle(color: kBlueAccent),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget signUpPage(context) {
    return LoadingOverlay(
      opacity: 0.1,
      isLoading: loading,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(30, 100, 30, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
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
                onPressed: () async {
                  showLoader();
                  try {
                    await signInSignUp.handleEmailPasswordSignUp(
                        context, email, password);
                    clearTextFeilds();
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
                  SizedBox(width: 5),
                  Text(
                    'Login',
                    style: TextStyle(color: kBlueAccent),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  int pageNumber = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> pageViewWidgets = [
      logInPage(context),
      signUpPage(context),
    ];

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Login',
                  style: TextStyle(
                      fontSize: pageNumber == 0 ? 35 : 18,
                      fontWeight: FontWeight.bold,
                      color: kBlueAccent),
                ),
                Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: pageNumber == 1 ? 35 : 18,
                      fontWeight: FontWeight.bold,
                      color: kBlueAccent),
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: PageController(
                  initialPage: pageNumber,
                ),
                children: pageViewWidgets,
                onPageChanged: (int index) {
                  clearTextFeilds();
                  setState(() {});
                  pageNumber = index;
                  print(pageNumber);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
