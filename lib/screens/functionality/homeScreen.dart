import 'package:emo_etry_app/authServices/auth.dart';
import 'package:emo_etry_app/constants/constants.dart';
import 'package:emo_etry_app/databaseServices/database.dart';
import 'package:emo_etry_app/helperFunctions/helperFunction.dart';
import 'package:emo_etry_app/screens/authentication/authenticate.dart';
import 'package:emo_etry_app/screens/functionality/historyPage.dart';
import 'package:emo_etry_app/screens/functionality/poemInputPage.dart';
import 'package:emo_etry_app/screens/functionality/userProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final String imagePath;
  const HomePage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthServices auth = AuthServices();
  DatabaseServices databaseServices = DatabaseServices(uid: Constants.userID);
  dynamic userInfo;
  int selectedIndex = 1;
  String imageUrl = "";

  PageController pageController = PageController(initialPage: 1);

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: [
          HistoryPage(),
          PoemInputPage(
            imagePath: widget.imagePath,
          ),
          UserProfilePage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E293B),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF1CF0D8),
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF1CF0D8),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF1CF0D8),
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xFF1CF0D8),
        unselectedItemColor: Colors.white,
        onTap: onTapped,
      ),
    );
  }
}
