import '../../../utils/app_strings.dart';

class PreviousLocation {
  PreviousLocation._internal();

  static final PreviousLocation _singleton = PreviousLocation._internal();
  static PreviousLocation get instance => _singleton;

  String? previousLocationName = AppStrings.emptyString;
  String? previousLocationDescription = AppStrings.emptyString;
  String? previousLocationId = AppStrings.emptyString;

  double? previousLatitude;
  double? previousLongitude;
  bool? isLocationEnable;
  bool? isDefaultLocation;
  bool? isPinAsCurrentLocation;

  void reset() {
    previousLocationName = AppStrings.emptyString;
    previousLocationDescription = AppStrings.emptyString;
    previousLocationId = AppStrings.emptyString;

    previousLatitude = 0.0;
    previousLongitude = 0.0;
    isLocationEnable = false;
    isDefaultLocation = false;
    isPinAsCurrentLocation = false;
  }
}
