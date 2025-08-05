import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_strings.dart';

class MarkerItemModel {
  String id;
  String title;
  String snippet;
  LatLng location;
  String imageString;

  MarkerItemModel({
    required this.id,
    this.title = AppStrings.emptyString,
    this.snippet = AppStrings.emptyString,
    required this.location,
    this.imageString = AppAssets.currLocIcon,
  });
}
