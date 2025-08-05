import 'package:helpampm/core/services/shared_preferences/shared_preference_constants.dart';
import 'package:helpampm/core/services/shared_preferences/shared_preference_helper.dart';
import 'package:helpampm/utils/app_constant.dart';

Map<String, String?> getRegisterServiceHeader() {
  Map<String, String?> header = {};
  String? token;

  token =
      SharedPreferenceHelper().getStringValue(SharedPreferenceConstants.token);

  if (token.isNotEmpty) {
    _addTokenHeader(header, token);
  }
  return header;
}

void _addTokenHeader(Map<String, String?> header, String? accessToken) {
  header[AppConstants.authorization] = "${AppConstants.bearer} $accessToken";
}
