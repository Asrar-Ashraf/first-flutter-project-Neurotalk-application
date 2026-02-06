import 'package:shared_preferences/shared_preferences.dart';

class Storegmailinshare {
  static SharedPreferences? _preferences;

  static const String gmailKey = "gmailkey";
  static const String userName = "gmailUsername";
  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveGmail(String gmail) async {
    await _preferences?.setString(gmailKey, gmail);
  }

  static Future<String?> getGmail() async {
    return _preferences?.getString(gmailKey);
  }

  static Future<void> setGmailUserName(String gmailUserName) async {
    await _preferences!.setString(userName, gmailUserName);
  }

  static Future<String?> getGmailUserName() async {
    return _preferences?.getString(userName);
  }
}
