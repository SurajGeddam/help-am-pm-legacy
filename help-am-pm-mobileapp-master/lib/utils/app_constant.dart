import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConstants {
  AppConstants._();

  static const String applicationName = "HELP";
  static const String appVersion = "1.2.10";

  static const fontFamily = "Roboto";


  // static const developmentURL = "http://10.0.2.2:8080";
  static const developmentURL = "https://www.apihelpampm.com";
  // static const developmentURL = "https://test.apihelpampm.com";
  // static const stripePublishableKey =
  //    "pk_test_51LpDphADXlW5EUPpEok3zJVmTKZc5x3j345M3LZbaxqFVcvQ5yJA9MEDL6ZF50ORjdDnTW9QoFCqLzyPYem5AN4300dEgpJN58";
  static const stripePublishableKey =
      "pk_live_51LpDphADXlW5EUPpcWill2jMyUGnbzREUEfVKZ1dkb076XG38BNMB33lLcWzPFUb5bbVOs5KtPHr4GnH7nPt2hM700Xk9jL2sP";
  static const String helpAmPmCom = "https://www.helpampm.com/";

  static const LatLng defaultLatLng = LatLng(28.628151, 77.367783);
  static const String defaultUploadFileName = "sample.jpg";

  static const String dateFormatMMDDYYYY = "MM-dd-yyyy";
  static const String dateFormatDDMMYYYY = "dd-MM-yyyy";
  static const String dateFormatHHMMA = "hh:mm a";
  static const String dateFormatDMMM = "d MMMM";
  static const String dateFormatHHMMSS = "hh:mm:ss";
  static const String dateFormatDDMMMYY = "dd MMM yy";
  static const String dateFormatYYYYMMDD = "yyyy-MM-dd";
  static const String dateFormatDDMMYYYYhhmmss = "yyyy-MM-ddThh:mm:ss";

  static const String routeServiceURL =
      'https://api.openrouteservice.org/v2/directions/';
  static const String mapAPIKey = 'AIzaSyAJ-H6Mxxzq17dMgmJnMRMpNjnOC8f78kA';

  static const String enLangCode = "en";
  static const String usCountryCode = "US";

  static const String esLangCode = "es";
  static const String esCountryCode = "ES";

  static const String dollor = "DOLLOR";
  static const String dollorSign = "\$";

  static const int locationTimer = 30;
  static const int recursionDelayTime = 3000;
  static String platform = Platform.isAndroid ? "ANDROID" : 'IOS';
  static const double speed = 30.00;

  static const String providerInsurance = "PROVIDER_INSURANCE";
  static const String providerLicense = "PROVIDER_LICENSE";
  static const String customerOrder = "CUSTOMER_ORDER";
  static const String userProfile = "USER_PROFILE";

  static const String category = "CATEGORY";
  static const String individual = "INDIVIDUAL";
  static const String insurance = "INSURANCE";
  static const String tradeLicense = "TRADE_LICENSE";
  static const String businessLicense = "BUSINESS_LICENSE";
  static const String vehicle = "VEHICLE";
  static const String bank = "BANK";
  static const String proTeamMembers = "PRO_TEAM_MEMBER";

  static const String history = "history";
  static const String schedule = "SCHEDULED";
  static const String notifications = "notifications";
  static const String helpNSupport = "helpNSupport";
  static const String contactUs = "contactUs";
  static const String changePassword = "changePassword";
  static const String logOut = "logOut";
  static const String newOrder = "newOrder";
  static const String settings = "SETTINGS";

  static const String faqs = "faqs";
  static const String howToUse = "howToUse";
  static const String askQueries = "askQueries";
  static const String deleteMyAccount = "deleteMyAccount";

  static const String ongoingOrders = "ongoingOrders";
  static const String savedAddress = "savedAddress";
  static const String savedCard = "savedCard";
  static const String invite = "invite";

  static const String superAdmin = "ROLE_SUPERADMIN";
  static const String customer = "ROLE_CUSTOMER";
  static const String provider = "ROLE_PROVIDER_ADMIN";
  static const String providerEmployee = "ROLE_PROVIDER_EMPLOYEE";

  static const String hvac = "hvac";
  static const String electrical = "electrical";
  static const String locksmith = "locksmith";
  static const String plumbing = "plumbing";

  static const String h = "H";
  static const String e = "E";
  static const String l = "L";
  static const String p = "P";

  static const String home = "HOME";
  static const String work = "WORK";
  static const String other = "OTHER";

  static const String crDrCard = "cr_dr_card";
  static const String paypal = "paypal";

  static const String authorization = "Authorization";
  static const String bearer = "Bearer";

  static const String started = "STARTED";
  static const String acceptedByProvider = "ACCEPTED_BY_PROVIDER";
  static const String paymentDone = "PAYMENT_DONE";
  static const String paymentPending = "PAYMENT_PENDING";
  static const String orderCancelled = "ORDER_CANCELLED";

  static const String sms = "SMS";
  static const String email = "EMAIL";

  static Position defaultPosition = Position(
    latitude: 0.0,
    longitude: 0.0,
    accuracy: 0.0,
    altitude: 0.0,
    altitudeAccuracy: 0.0,
    heading: 0.0,
    headingAccuracy: 0.0,  // added to satisfy new plugin API
    speed: 0.0,
    speedAccuracy: 0.0,
    timestamp: DateTime(2024, 1, 1),  // fixed nullability issue
  );
}
