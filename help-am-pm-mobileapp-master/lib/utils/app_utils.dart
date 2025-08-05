import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Directory, Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpampm/modules/login/bloc/login_bloc/login_bloc.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_constant.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/services/shared_preferences/shared_preference_constants.dart';
import '../core/services/shared_preferences/shared_preference_helper.dart';
import '../core_components/common_models/device_info_model.dart';
import '../core_components/common_widgets/show_snack_text_widget.dart';
import '../core_components/i18n/language_codes.dart';
import '../modules/address/model/save_address_model/request_body/save_address_req_body_model.dart';
import '../modules/login/ui/login_screen.dart';
import 'app_colors.dart';
import 'app_decoder.dart';
import 'app_regex_constant.dart';
import 'app_strings.dart';

class AppUtils {
  AppUtils._();

  static const double mockupHeight = 812.0;
  static const double mockupWidth = 375.0;
  static double deviceHeight = 0.0;
  static double deviceWidth = 0.0;

  static debugPrint(dynamic printText) {
    if (kDebugMode) log(printText?.toString() ?? AppStrings.nullString);
  }

  static logout() {
    Future.delayed(Duration.zero, () {
      SharedPreferenceHelper().clearPreferenceValues();
      AppUtils.debugPrint(
          "SharedPreferenceHelper() => ${SharedPreferenceHelper().getStringValue("role")}");
      final ctx = GlobalKeys.navigatorKey.currentState?.context;
      if (ctx != null) {
        ScaffoldMessenger.of(ctx).clearSnackBars();
        Navigator.of(ctx).pushNamedAndRemoveUntil(
            LoginScreen.routeName, (Route<dynamic> route) => true);
      }
    });
  }

  static getLocationIconOnMap(String value) {
    switch (value) {
      case AppConstants.h:
        return AppAssets.carIconH;
      case AppConstants.e:
        return AppAssets.carIconE;
      case AppConstants.l:
        return AppAssets.carIconL;
      case AppConstants.p:
        return AppAssets.carIconP;
      default:
        return AppAssets.carIcon;
    }
  }

  static getCurrencySymbol(String currencySymbol) {
    switch (currencySymbol) {
      case AppConstants.dollor:
        return AppConstants.dollorSign;

      default:
        return AppConstants.dollorSign;
    }
  }

  static showSnackBar(
    String text, {
    IconData? icon,
    Color bgColor = AppColors.black,
    Color iconColor = AppColors.white,
    Color textColor = AppColors.white,
    int duration = 3,
  }) {
    final ctx = GlobalKeys.navigatorKey.currentState?.context;
    bool isShowSnackBarActive = false;

    if (ctx != null && !isShowSnackBarActive) {
      isShowSnackBarActive = true;
      ScaffoldMessenger.of(ctx)
          .showSnackBar(
            SnackBar(
              content: ShowSnackTextWidget(
                text: text,
                icon: icon,
                iconColor: iconColor,
                textColor: textColor,
              ),
              backgroundColor: bgColor,
              duration: Duration(seconds: duration),
            ),
          )
          .closed
          .then((value) => isShowSnackBarActive = false);
    }
  }

  static String getUploadFileName(String? name) {
    String fileName = AppConstants.defaultUploadFileName;
    if (name == null) {
      return fileName;
    }
    var arr = name.split('_');
    fileName = arr[arr.length - 1];
    return fileName;
  }

  static showDateHHMM(String value) {
    List<String> dateList = value.split(":");
    if (dateList.length == 3) {
      return ("${dateList[0]}:${dateList[1]}");
    } else {
      return AppStrings.emptyString;
    }
  }

  static saveDateToServer(String value) {
    List<String> dateList = value.split("-");
    if (dateList.length == 3) {
      return ("${dateList[2]}-${dateList[0]}-${dateList[1]}");
    } else {
      return AppStrings.emptyString;
    }
  }

  static getDateHhMmSs(DateTime? dateTime) {
    if (dateTime == null) return AppStrings.emptyString;
    var formatter = DateFormat(AppConstants.dateFormatHHMMSS);
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  static getDateHhMmA(DateTime? dateTime) {
    if (dateTime == null) return AppStrings.emptyString;
    var formatter = DateFormat(AppConstants.dateFormatHHMMA);
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  /// 01 March
  static getDatedMMM(DateTime? dateTime) {
    if (dateTime == null) return AppStrings.emptyString;
    var formatter = DateFormat(AppConstants.dateFormatDMMM);
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  /// 24-01-2023
  /*static getDateDDMMYYYY(DateTime? dateTime) {
    if (dateTime == null) return AppStrings.emptyString;
    var formatter = DateFormat(AppConstants.dateFormatDDMMYYYY);
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }*/

  /// 07-05-2023
  static getDateMMDDYYYY(DateTime? dateTime) {
    if (dateTime == null) return AppStrings.emptyString;
    var formatter = DateFormat(AppConstants.dateFormatMMDDYYYY);
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  static getDateDDMMYYYYhhmmss(DateTime? dateTime) {
    if (dateTime == null) return AppStrings.emptyString;
    var formatter = DateFormat(AppConstants.dateFormatDDMMYYYYhhmmss);
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  /// 2023-01-25
  static getDateYYYYMMDD(DateTime? dateTime) {
    if (dateTime == null) return AppStrings.emptyString;
    var formatter = DateFormat(AppConstants.dateFormatYYYYMMDD);
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  /// 01 March 2023
  static getFormattedDate(DateTime? dateTime,
      {String formatString = AppConstants.dateFormatDMMM}) {
    if (dateTime == null) return AppStrings.emptyString;
    var formatter = DateFormat(formatString);
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  static Future<void> launchDeepLinkURL(
      {String url = AppConstants.helpAmPmCom}) async {
    try {
      if (Platform.isIOS) {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchExternalApp(url);
        }
      } else {
        await launchExternalApp(url);
      }
    } catch (e) {
      await launchExternalApp(url);
    }
  }

  static Future<bool> launchExternalApp(String url) {
    return launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  static void navigateToMap(LatLng latLng) async {
    if (Platform.isAndroid) {
      String uri =
          "google.navigation:q=${latLng.latitude},${latLng.longitude}&mode=d";
      launchDeepLinkURL(url: uri);
    } else {
      var urlAppleMaps =
          'https://maps.apple.com/?q=${latLng.latitude},${latLng.longitude}';
      var url =
          'comgooglemaps://?saddr=&daddr=${latLng.latitude},${latLng.longitude}&directionsmode=driving';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
        await launchUrl(Uri.parse(urlAppleMaps));
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  static Future<void> sendEmail(
      String mailTo, String subject, String body) async {
    final Uri launchUri =
        Uri(scheme: 'mailto', path: '$mailTo?subject=$subject&body=$body');
    await launchUrl(launchUri);
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> openURL(Uri url) async {
    // final Uri toLaunch =
    //     Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  static double calculateDistanceByLatLng(
      {required LatLng latLng1,
      required LatLng latLng2,
      bool isInMeter = true}) {
    double distanceBetween = Geolocator.distanceBetween(latLng1.latitude,
        latLng1.longitude, latLng2.latitude, latLng2.longitude);
    return isInMeter ? distanceBetween : (distanceBetween * 0.001);
  }

  static String differenceBtTwoTime(
      {DateTime? startDateTime, DateTime? stopDateTime}) {
    String result = AppStrings.emptyString;
    if (startDateTime == null && stopDateTime == null) {
      return result;
    } else {
      int? difference = stopDateTime?.difference(startDateTime!).inMinutes;
      result = durationMinToHrsString(difference ?? 0);
    }
    return result;
  }

  static String durationMinToHrsString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  static String getSelectedLanguage() {
    String selectedLanguage =
        (AppUtils._getDefaultLanguage() == LanguageCodes.english.code)
            ? LanguageCodes.english.code
            : LanguageCodes.spanish.code;
    return selectedLanguage;
  }

  static String _getDefaultLanguage() {
    String languageCode = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.languageCode);
    return (languageCode.isEmpty)
        ? ((Platform.localeName.contains(LanguageCodes.english.code))
            ? LanguageCodes.english.code
            : LanguageCodes.spanish.code)
        : languageCode;
  }

  static double getHeight(var height) {
    var percent = ((height / mockupHeight) * 100);
    return ((deviceHeight * percent) / 100);
  }

  static double getWidth(var width) {
    var percent = ((width / mockupWidth) * 100);
    return ((deviceWidth * percent) / 100);
  }

  static double getFs(var sp) {
    var percent = (((sp - 0.25) / mockupWidth) * 100);
    return ((mockupWidth * percent) / 100);
  }

  static double getRadius(var radius) {
    return double.parse(radius.toString());
  }

  static bool accessTokenIsValid() {
    SharedPreferenceHelper preference = SharedPreferenceHelper();

    if (!preference.getIsUserLogin()) {
      return false;
    }

    String token = preference.getStringValue(SharedPreferenceConstants.token);
    String expiryDate =
        preference.getStringValue(SharedPreferenceConstants.expiryDate);

    bool isExpired = isEmpty(token)
        ? true
        : (isEmpty(expiryDate) ? true : AppDecoder.isExpired(expiryDate));
    return !isExpired;
  }

  static Future<bool> refreshTokenIsValid() async {
    SharedPreferenceHelper preference = SharedPreferenceHelper();
    String? token;
    String? expiryDate;

    if (!preference.getIsUserLogin()) {
      return false;
    }

    String str =
        preference.getStringValue(SharedPreferenceConstants.refreshTokenObj);

    if (!isEmpty(str)) {
      await preference.getRefreshTokenObj().then((value) {
        token = value?.token;
        expiryDate = value?.expiryDate;
      });
    }

    bool isExpired = isEmpty(token)
        ? true
        : (isEmpty(expiryDate) ? true : AppDecoder.isExpired(expiryDate));

    if (!isExpired) {
      preference.setStringValue(SharedPreferenceConstants.token, token);
      preference.setStringValue(
          SharedPreferenceConstants.expiryDate, expiryDate);
    }
    return !isExpired;
  }

  static Future<bool> getNewAccessToken() async {
    if (!SharedPreferenceHelper().getIsUserLogin()) {
      return false;
    }
    return await LoginBloc().refreshToken();
  }

  static getLocationName(SaveAddressReqBodyModel? address) {
    String addressName = "";
    if (address != null && address.house.isNotEmpty) {
      addressName = addressName + address.house;
    }
    if (address != null && address.building.isNotEmpty) {
      addressName = "$addressName ${address.building}";
    }
    if (address != null && address.street.isNotEmpty) {
      addressName = "$addressName ${address.street}";
    }
    if (address != null && address.street.isNotEmpty) {
      addressName = "$addressName ${address.zipcode}";
    }

    return addressName;
  }

  static bool getIsRoleCustomer() {
    return SharedPreferenceHelper().getIsRoleCustomer();
  }

  static Future<bool> saveDeviceToken(String deviceToken) async {
    bool status = await SharedPreferenceHelper().setDeviceToken(deviceToken);
    return status;
  }

  static String getDeviceToken() {
    return SharedPreferenceHelper().getDeviceToken();
  }

  static Future<bool> setDeviceTokenUpdateStatus(bool deviceTokenStatus) async {
    bool status =
        await SharedPreferenceHelper().setDeviceTokenUpdated(deviceTokenStatus);
    return status;
  }

  static bool isDeviceTokenUpdated() {
    return SharedPreferenceHelper().isDeviceTokenUpdated();
  }

  static Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err, stack) {
      AppUtils.debugPrint("Cannot get download folder path $stack");
    }
    return directory?.path;
  }

  static bool validateStructure(String value) {
    RegExp regExp = RegExp(regPassword);
    return regExp.hasMatch(value);
  }

  static Uint8List convertImage(String bytes) {
    Uint8List bytesCode = const Base64Codec().decode(bytes);
    return bytesCode;
  }
}

double getDefaultDoubleValue(double? value) {
  return value ?? 0.0;
}

String getDefaultStringValue(String? value) {
  return value ?? AppStrings.emptyString;
}

bool isNotEmpty(String? str) {
  return (str != null || str != AppStrings.emptyString);
}

bool isEmpty(String? str) {
  return (str == null || str == AppStrings.emptyString);
}

Future<DeviceInput> getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AppUtils.debugPrint("-----Getting android device info----");
    var androidInfo = await deviceInfoPlugin.androidInfo;
    DeviceInput device = DeviceInput(
      deviceToken: AppUtils.getDeviceToken(),
      // appVersion: packageInfo.version,
      brand: androidInfo.brand,
      deviceId: androidInfo.type,
      jailbreak: "",
      // model: androidInfo.androidId,
      os: '${androidInfo.version.sdkInt}',
    );
    return device;
  } else {
    AppUtils.debugPrint("-----Getting IOS device info----");
    var iosInfo = await deviceInfoPlugin.iosInfo;
    DeviceInput device = DeviceInput(
      deviceToken: AppUtils.getDeviceToken(),
      deviceId: iosInfo.identifierForVendor,
      jailbreak: "",
      model: iosInfo.model,
      os: iosInfo.systemVersion,
    );
    return device;
  }
}

class GlobalKeys {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: AppStrings.mainNavigator);
}

extension SizeExt on num {
  double get sw => AppUtils.getWidth(this);

  double get sh => AppUtils.getHeight(this);

  double get fs => AppUtils.getFs(this);

  double get r => AppUtils.getRadius(this);
}
