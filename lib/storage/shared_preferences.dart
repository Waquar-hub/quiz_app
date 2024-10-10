

import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static SharedPreferences? _preferences;

  static const keyUserAccessToken = 'userAccessToken';

  static const keyScore = 'key_score';

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  ///  set Access Token into "_keyUserAccessToken" variable ///
  static Future setUserAccessToken(String useraccess) async => await _preferences?.setString(keyUserAccessToken, useraccess);
  ///  get Access Token from "_keyUserAccessToken" variable ///
  static String? getUserAccessToken() => _preferences!.getString(keyUserAccessToken);

  /// Set User highest Score Id ///
  static Future setScore(double userEmailId) async => await _preferences!.setDouble(keyScore, userEmailId);

  /// get User highest Score Id ///
  static double? getScore() => _preferences!.getDouble(keyScore);


  static clear(){
    _preferences!.clear();
  }

}