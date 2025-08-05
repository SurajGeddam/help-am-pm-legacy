import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../utils/app_constant.dart';
import '../../../utils/app_strings.dart';
import '../location/location_manager_handler.dart';
import 'previous_location.dart';

enum LocationCubitState { initial, loaded }

class LocationCubit extends Cubit<LocationCubitState> with ChangeNotifier {
  LocationCubit() : super(LocationCubitState.initial);

  String defaultLocationName = AppStrings.emptyString;
  String defaultLocationDescription = AppStrings.emptyString;
  Position latestPosition = AppConstants.defaultPosition;
  Position currentPosition = AppConstants.defaultPosition;
  bool isLocationEnabled = false;
  PreviousLocation previousLocationCache = PreviousLocation.instance;

  Future<void> getCurrentLocation() async {
    if (PreviousLocation.instance.previousLatitude != null &&
        PreviousLocation.instance.previousLatitude != 0.0) {
      emit(LocationCubitState.loaded);
    } else {
      await getCurrentPosition();
    }
  }

  Future<void> getCurrentPosition() async {
    isLocationEnabled = await LocationManagerHandler.shared.isLocationEnable();
    if (isLocationEnabled) {
      LocationManagerHandler.shared.getUserLatLng().then((value) {
        currentPosition = Position(
          latitude: value?.latitude ?? AppConstants.defaultPosition.latitude,
          longitude: value?.longitude ?? AppConstants.defaultPosition.longitude,
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          timestamp: null,
        );
      }).whenComplete(() async {
        return loadPreviousLocation();
      }).onError((error, stackTrace) {
        return loadPreviousLocation();
      });
    } else {
      return loadPreviousLocation();
    }
  }

  loadPreviousLocation() {
    if (isLocationEnabled) {
      _setPinToCurrentLocation();
    } else {
      _setPinToDefaultLocation();
    }
  }

  initDefaultLocation(String locationName, String locationDescription) {
    defaultLocationName = locationName;
    defaultLocationDescription = locationDescription;
  }

  // _setPinLocationAndLocationName(Position defaultPosition) {
  //   if (isLocationEnabled!) {
  //     _setPinToCurrentLocation();
  //   } else {
  //     _setPinToDefaultLocation();
  //   }
  // }

  _setPinToDefaultLocation() {
    _saveLocation(
      pinLocationName: defaultLocationName,
      pinLocationDescription: defaultLocationDescription,
      locationId: AppStrings.emptyString,
      latitude: AppConstants.defaultPosition.latitude,
      longitude: AppConstants.defaultPosition.longitude,
      isDefaultLocation: true,
      isLocationEnable: isLocationEnabled,
      isPinAsCurrentLocation: false,
    );
  }

  /*_setPinToPreviousLocation(PinLocationModel pinLocationModel) {
    _saveLocation(
        pinLocationName: pinLocationModel.data!.pinLocation!.locationName,
        pinLocationDescription:
            pinLocationModel.data!.pinLocation!.locationDescription,
        locationId: pinLocationModel.data!.pinLocation!.locationId,
        latitude: pinLocationModel.data!.pinLocation!.latitude,
        longitude: pinLocationModel.data!.pinLocation!.longitude,
        isDefaultLocation: false,
        isLocationEnable: isLocationEnabled,
        isPinAsCurrentLocation: false);
  }*/

  _setPinToCurrentLocation() {
    reverseGeocoding(currentPosition.latitude, currentPosition.longitude);
  }

  reverseGeocoding(double lat, double lng) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
      _saveLocation(
          pinLocationName: placeMarks.first.name,
          pinLocationDescription:
              '${placeMarks.first.street} ${placeMarks.first.subLocality} ${placeMarks.first.locality}'
              '\n${placeMarks.first.administrativeArea} ${placeMarks.first.postalCode} '
              '${placeMarks.first.country}',
          locationId: AppStrings.emptyString,
          latitude: currentPosition.latitude,
          longitude: currentPosition.longitude,
          isDefaultLocation: false,
          isLocationEnable: isLocationEnabled,
          isPinAsCurrentLocation: true);
    } catch (e) {
      _setPinToDefaultLocation();
    }
  }

  _saveLocation(
      {String? pinLocationName = AppStrings.emptyString,
      String? pinLocationDescription = AppStrings.emptyString,
      String? locationId,
      double? latitude,
      double? longitude,
      bool? isDefaultLocation,
      bool? isLocationEnable,
      bool? isPinAsCurrentLocation}) async {
    previousLocationCache.previousLocationName = pinLocationName;
    previousLocationCache.previousLocationDescription = pinLocationDescription;
    previousLocationCache.previousLocationId = locationId;
    previousLocationCache.previousLatitude = latitude;
    previousLocationCache.previousLongitude = longitude;
    previousLocationCache.isDefaultLocation = isDefaultLocation;
    previousLocationCache.isLocationEnable = isLocationEnable;
    previousLocationCache.isPinAsCurrentLocation = isPinAsCurrentLocation;
    emit(LocationCubitState.loaded);
    notifyListeners();
  }

  Future<List<Placemark>> getPlaceMarks(lat, lng) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
    return placeMarks;
  }

  Future<String> getAddressDescriptionByLatLng(lat, lng) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
    String locationDescription =
        '${placeMarks.first.street} ${placeMarks.first.subLocality} ${placeMarks.first.locality} '
        '\n${placeMarks.first.administrativeArea} ${placeMarks.first.postalCode} '
        '${placeMarks.first.country}';
    return locationDescription;
  }

  Position getPosition() {
    return Position(
      latitude: PreviousLocation.instance.previousLatitude ??
          AppConstants.defaultLatLng.latitude,
      longitude: PreviousLocation.instance.previousLongitude ??
          AppConstants.defaultLatLng.longitude,
      timestamp: null,
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }
}
