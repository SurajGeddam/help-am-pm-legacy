import 'dart:convert';
import 'package:helpampm/utils/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../modules/login/model/login_model/auth_token_model.dart';
import '../../../utils/app_strings.dart';
import 'shared_preference_constants.dart';

class SharedPreferenceHelper {
  SharedPreferences? _preferences;

  SharedPreferenceHelper._internal();

  static final SharedPreferenceHelper _singleton =
      SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() => _singleton;

  init() async => _preferences = await SharedPreferences.getInstance();

  Future<bool?> clearPreferenceValues() async {
    return await _preferences?.clear();
  }

  Future<bool> setStringValue(String key, String? value) async {
    return await _preferences?.setString(
            key, value ?? AppStrings.emptyString) ??
        false;
  }

  String getStringValue(String key) {
    return _preferences?.getString(key) ?? AppStrings.emptyString;
  }

  Future<bool> setIntValue(String key, int? value) async {
    return await _preferences?.setInt(key, value ?? -1) ?? false;
  }

  int getIntValue(String key) {
    return _preferences?.getInt(key) ?? -1;
  }

  Future<bool> setBoolValue(String key, bool? value) async {
    return await _preferences?.setBool(key, value ?? false) ?? false;
  }

  bool getBoolValue(String key) {
    return _preferences?.getBool(key) ?? false;
  }

  Future<bool> setIsUserLogin(bool? value) async {
    return await setBoolValue(SharedPreferenceConstants.login, value);
  }

  bool getIsUserLogin() {
    return getBoolValue(SharedPreferenceConstants.login);
  }

  Future<bool> setUserDetailsDto(UserDetailsDto? userDetailsDto) async {
    String userDetailsDtoObj = jsonEncode(userDetailsDto);
    return setStringValue(
        SharedPreferenceConstants.userDetailsDto, userDetailsDtoObj);
  }

  Future<UserDetailsDto?> getUserDetailsDto() async {
    var map = await jsonDecode(
        getStringValue(SharedPreferenceConstants.userDetailsDto));
    UserDetailsDto userDetailsDto = UserDetailsDto.fromJson(map);
    return userDetailsDto;
  }

  Future<bool> setRefreshTokenObj(RefreshToken? refreshTokenObj) async {
    String refreshToken = jsonEncode(refreshTokenObj);
    return setStringValue(
        SharedPreferenceConstants.refreshTokenObj, refreshToken);
  }

  Future<RefreshToken?> getRefreshTokenObj() async {
    var map = await jsonDecode(
        getStringValue(SharedPreferenceConstants.refreshTokenObj));
    RefreshToken refreshTokenObj = RefreshToken.fromJson(map);
    return refreshTokenObj;
  }

  Future<bool> setIsRoleCustomer(bool? value) async {
    return await setBoolValue(SharedPreferenceConstants.isRoleCustomer, value);
  }

  bool getIsRoleCustomer() {
    return getBoolValue(SharedPreferenceConstants.isRoleCustomer);
  }

  Future<bool> setDeviceToken(String value) async {
    AppUtils.debugPrint(
        "---- saving deviceToken ----- shared preferences helper: $value");
    return await setStringValue(SharedPreferenceConstants.deviceToken, value);
  }

  String getDeviceToken() {
    return getStringValue(SharedPreferenceConstants.deviceToken);
  }

  Future<bool> setDeviceTokenUpdated(bool value) async {
    return await setBoolValue(
        SharedPreferenceConstants.deviceTokenStatus, value);
  }

  bool isDeviceTokenUpdated() {
    return getBoolValue(SharedPreferenceConstants.deviceTokenStatus);
  }
}
