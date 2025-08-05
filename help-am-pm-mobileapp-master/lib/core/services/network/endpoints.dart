import 'package:helpampm/utils/app_constant.dart';

class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = AppConstants.developmentURL;

  // timeout
  static const int receiveTimeout = 30000;
  static const int connectionTimeout = 30000;

  static const String getToken = "/auth/token";
  static const String refreshToken = "/auth/refreshtoken";
}
