import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String sharedPreferenceLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserIdKey = "USERIDKEY";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";

//Saving the userLogged in status to sharedPreference
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceLoggedInKey, isUserLoggedIn);
  }

//Retrieving user logged in status from shared Preference
  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceLoggedInKey) ?? false;
  }

//Saving userID to shared Preference
  static Future<bool> saveUserIDSharedPreference(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserIdKey, userID);
  }

  //Retrieving userID from sharedPreference
  static Future<String?> getUserIDSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserIdKey);
  }
}
