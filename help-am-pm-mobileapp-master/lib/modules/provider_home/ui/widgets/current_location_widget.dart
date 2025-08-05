import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../core_components/common_widgets/google_map_widget.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';

class CurrentLocationWidget extends StatelessWidget {
  final Position position;

  const CurrentLocationWidget({
    Key? key,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.deviceWidth,
      margin: EdgeInsets.only(left: 20.sw, right: 20.sw, top: 24.sh),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.yourCurrentLocation,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 16.fs,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
            textAlign: TextAlign.left,
          ),
          Container(
            height: 150.sh,
            width: double.infinity,
            margin: EdgeInsets.only(top: 20.sh),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: GoogleMapWidget(
              latLng: LatLng(position.latitude, position.longitude),
              zoomValue: 18.0,
            ),
          )
        ],
      ),
    );
  }
}
