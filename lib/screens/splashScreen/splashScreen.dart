import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emo_etry_app/constants/constants.dart';
import 'package:emo_etry_app/helperFunctions/helperFunction.dart';
import 'package:emo_etry_app/screens/authentication/authenticate.dart';
import 'package:emo_etry_app/screens/functionality/homeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isUserLoggedIn = false;

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        isUserLoggedIn = value;
      });
    });

    await HelperFunction.getUserIDSharedPreference().then((value) {
      Constants.userID = value.toString();
      print("Shared Preference userId:" + value.toString());
      print("Constant UserId:" + Constants.userID);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
    Timer(
        const Duration(seconds: 3),
        () => {
              Get.off(
                  () => isUserLoggedIn
                      ? const HomePage(
                          imagePath: "",
                        )
                      : const Authenticate(),
                  transition: Transition.circularReveal,
                  duration: const Duration(milliseconds: 5400)),
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff1D0E54),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 400,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(400),
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                        "assets/Blue and White Minimalist Illustrated Electric Technology Logo.gif"),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
