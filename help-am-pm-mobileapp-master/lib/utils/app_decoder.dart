import 'app_utils.dart';

class AppDecoder {
  static bool isExpired(String? expiryDate) {
    if (isEmpty(expiryDate)) {
      return true;
    }
    DateTime dateTime = DateTime.parse(expiryDate!);
    bool value = DateTime.now().isAfter(dateTime);
    AppUtils.debugPrint("Session time is expired ($dateTime) => $value");
    return value;
  }
}
