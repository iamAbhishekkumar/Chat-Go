import 'package:shared_preferences/shared_preferences.dart';

class SaveData {
  static String sharedPreferenceUserLoggedinKey = 'ISLOGGEDIN';
  static String sharedPreferenceUserNameKey = 'USERNAMEKEY';

  static saveUserLoggedInPreferences(bool isloggedin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedinKey, isloggedin);
  }

  static saveUserNameInPreferences(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, name);
  }

  static getUserLoggedInPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedinKey);
  }

  static getUserNameInPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static removeUserNameInPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(sharedPreferenceUserNameKey);
  }
}
