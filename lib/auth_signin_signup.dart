import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:people_chat/sign_in_screen.dart';
import 'sign_up_screen.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignInPage(toggleView);
    } else {
      return SignUpPage(toggleView);
    }
  }
}