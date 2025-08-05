import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helpampm/utils/app_constant.dart';
import 'package:location/location.dart' as location;
import '../../../utils/app_strings.dart';
import '../../../utils/app_utils.dart';
import 'location_alert_widget.dart';

class LocationManagerHandler {
  final Duration _minTimeSec = const Duration(seconds: 15);
  Position defaultPosition = AppConstants.defaultPosition;

  LocationManagerHandler._privateConstructor();

  /// this single instance will be used to grant location permission or sending location
  static final LocationManagerHandler shared =
      LocationManagerHandler._privateConstructor();

  factory LocationManagerHandler() => shared;

  /// [checkPermissions] will return device selected permissions
  Future<LocationPermission> checkPermissions() async {
    return await Geolocator.checkPermission();
  }

  /// [askForPermission] will check and ask for location permission
  Future<bool?> askForPermission({bool openAppSettings = false}) async {
    ///check for existing location permission and request in case of denied
    LocationPermission permission = await Geolocator.checkPermission();
    AppUtils.debugPrint("permission => $permission");

    try {
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        return true;
      } else if (permission == LocationPermission.denied) {
        LocationPermission permission = await Geolocator.requestPermission();
        return (permission == LocationPermission.deniedForever) ? false : true;
      } else if (permission == LocationPermission.deniedForever) {
        if (openAppSettings) {
          await Geolocator.openLocationSettings();
          return false;
        }
        LocationPermission settingsPermission =
            await Geolocator.checkPermission();
        return settingsPermission == LocationPermission.always ||
            settingsPermission == LocationPermission.whileInUse;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> isLocationEnable() async {
    bool isLocationEnableService = await Geolocator.isLocationServiceEnabled();
    return isLocationEnableService;
  }

  Future<bool> checkLocationPermissions() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    return (locationPermission == LocationPermission.whileInUse ||
        locationPermission == LocationPermission.always);
  }

  /// [requestLocationServicePermission] will return true if user allow device location else return false
  Future<bool> requestLocationServicePermission() async {
    bool locationServiceReq = await location.Location().requestService();
    return locationServiceReq;
  }

  /// [getCurrentLocation] will return the current location of device
  Future<Position>? getCurrentLocation(
      {LocationAccuracy accuracy = LocationAccuracy.medium}) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: accuracy,
      forceAndroidLocationManager: true,
      timeLimit: _minTimeSec,
    );
    return position;
  }

  Future<Position?> getUserLatLng() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission locationPermission = await checkPermissions();
        if (locationPermission == LocationPermission.whileInUse ||
            locationPermission == LocationPermission.always) {
          Position? currentLocation = await getCurrentLocation();
          return currentLocation ?? AppConstants.defaultPosition;
        }
      } else {
        if (GlobalKeys.navigatorKey.currentState?.context != null) {
          LocationAlert()
              .showAlert(GlobalKeys.navigatorKey.currentState?.context);
        }
      }
      return defaultPosition;
    } catch (e) {
      return defaultPosition;
    }
  }

  Future<void> resetLocationAndFetch() async {
    await getUserLatLng();
  }

  static double distanceBetweenInKm(
      double startLat, double startLng, double endLat, double endLng) {
    /// distance in kiloMeters
    double distanceInKiloMeters =
        Geolocator.distanceBetween(startLat, startLng, endLat, endLng) / 1000;
    return double.parse((distanceInKiloMeters).toStringAsFixed(2));
  }

  Future<String> getPermissionLocationString() async {
    LocationPermission permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.always:
        return AppStrings.allowOnce;
      case LocationPermission.whileInUse:
        return AppStrings.alwaysAllowWhileUsingApp;
      default:
        return AppStrings.notAllow;
    }
  }

  Future<Location> revertAddress(String query) async {
    List<Location> locations = await locationFromAddress(query);
    Location coordinates = locations[0];
    AppUtils.debugPrint(
        "Position => ${coordinates.latitude}, ${coordinates.longitude}");
    return coordinates;
  }

  Future<Location> getLocationFromAddress(String subDistrictText,
      String districtText, String provinceText, String postalCodeText) async {
    try {
      final String query =
          '$subDistrictText $districtText $provinceText $postalCodeText';
      return await LocationManagerHandler().revertAddress(query);
    } catch (e) {
      try {
        final String query = '$provinceText $postalCodeText';
        return await LocationManagerHandler().revertAddress(query);
      } catch (e) {
        AppUtils.debugPrint(e);
        return Location(
          latitude: defaultPosition.latitude,
          longitude: defaultPosition.longitude,
          timestamp: DateTime.now(),
        );
      }
    }
  }
}
