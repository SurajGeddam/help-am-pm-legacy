import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';

class LocationDisableWidget extends StatelessWidget {
  const LocationDisableWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.deviceWidth,
      margin: EdgeInsets.only(left: 20.sw, right: 20.sw, top: 20.sh),
      padding: EdgeInsets.all(12.sw),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppColors.red,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        AppStrings.locationDisableMessage,
        style: AppTextStyles.defaultTextStyle.copyWith(
          fontSize: 12.fs,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
        ),
        maxLines: 2,
      ),
    );
  }
}
