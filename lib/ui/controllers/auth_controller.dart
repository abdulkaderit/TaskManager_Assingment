import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_liveclass/data/models/user_model.dart';

class AuthController{
  static String? token;
  static UserModel? userInfoModel;
  static Logger _logger = Logger();

  static const String _tokenKey = 'token';
  static const String _userDataKey = 'user-data';

  // Save user information to shared preferences
  static Future<void> saveUserInformation( String accessToken, UserModel user)async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString( _tokenKey, accessToken);
  sharedPreferences.setString( _userDataKey, jsonEncode(user.toJson()));

  _logger.w('Data Saved');

  token = accessToken;
  userInfoModel = user;

  _logger.i("This Is Save Data: $userInfoModel");
 }
 // Get user information
 static Future <void> getUserInformation()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(_tokenKey);
    String? savedUserModelString = sharedPreferences.getString(_userDataKey);

    if(savedUserModelString != null){
      UserModel savedUserModel = UserModel.fromJson(jsonDecode(savedUserModelString));
      userInfoModel  = savedUserModel;
    }
    token = accessToken;

    if (userInfoModel?.firstName != null) {
      _logger.w('User Got the data successfully');
    }

  }
  // Check if user is logged in
  static Future<bool> checkIfUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userAccessToken = sharedPreferences.getString(_tokenKey);

    if (userAccessToken != null){
      await getUserInformation();
      return true;
    }
    return false;
  }
  static Future <void> clearUserData()async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    token = null;
    userInfoModel = null;

    _logger.i('Token: ==> $token & cleared');
    _logger.i('Token: ==> $userInfoModel & cleared');

  }
}