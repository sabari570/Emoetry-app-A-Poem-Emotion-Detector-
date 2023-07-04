import 'package:emo_etry_app/screens/authentication/loginPage.dart';
import 'package:emo_etry_app/screens/authentication/singUpPage.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
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
    if (showSignIn == true) {
      return LoginScreen(
        toggleView: toggleView,
      );
    } else {
      return RegisterScreen(
        toggleView: toggleView,
      );
    }
  }
}
