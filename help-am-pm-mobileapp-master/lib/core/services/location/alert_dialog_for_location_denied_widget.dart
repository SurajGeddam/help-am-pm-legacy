import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../utils/app_assets.dart';

class AlertDialogForLocationDeniedWidget extends StatelessWidget {
  final VoidCallback? onPressedOk;

  const AlertDialogForLocationDeniedWidget({
    Key? key,
    this.onPressedOk,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.sw),
          padding: EdgeInsets.symmetric(horizontal: 20.sw, vertical: 40.sh),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 86.sh,
                width: 86.sw,
                child: Image.asset(
                  AppAssets.gpsIconPng,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 16.sh),
              Text(
                AppStrings.requestLocationTitle,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 28.fs,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.sh),
              Text(
                AppStrings.requestLocationTitleMsg,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 18.fs,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.sh),
              BottomButtonWidget(
                buttonTitle: AppStrings.ok,
                buttonBGColor: AppColors.black,
                onPressed: onPressedOk,
              )
            ],
          ),
        ),
      ),
    );
  }
}
