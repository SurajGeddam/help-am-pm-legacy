import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class LocationWithAddressWidget extends StatelessWidget {
  final String locationName;
  final String locationDescription;
  final VoidCallback? onTapChangeBtn;
  final bool isChangeBtnShow;

  const LocationWithAddressWidget({
    Key? key,
    required this.locationName,
    required this.locationDescription,
    this.onTapChangeBtn,
    this.isChangeBtnShow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        isChangeBtnShow
            ? ElevatedButton(
                onPressed: onTapChangeBtn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appYellow,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(vertical: 12.sh, horizontal: 24.sw),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                  ),
                ),
                child: Text(
                  AppStrings.changeAddress.toUpperCase(),
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : const Offstage(),
        Padding(
          padding: EdgeInsets.only(top: 12.sh, bottom: 6.sh),
          child: Text(
            locationName,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 24.fs,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
            maxLines: 1,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          locationDescription,
          style: AppTextStyles.defaultTextStyle.copyWith(
            fontSize: 16.fs,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
          maxLines: 2,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
