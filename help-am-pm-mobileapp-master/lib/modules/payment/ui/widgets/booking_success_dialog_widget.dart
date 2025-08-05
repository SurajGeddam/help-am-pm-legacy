import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class BookingSuccessDialogWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const BookingSuccessDialogWidget({
    Key? key,
    this.onPressed,
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
              SvgPicture.asset(
                AppAssets.rightSvgIcon,
                height: 66.sh,
                fit: BoxFit.fill,
                color: AppColors.appGreen,
              ),
              SizedBox(height: 18.sh),
              Text(
                AppStrings.thankYouForBookingWithUs,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 28.fs,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 54.sh),
              Text(
                AppStrings.estimatedAmountToBePaid,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 16.fs,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.sh),
              Text(
                "\$125",
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 24.fs,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.sh),
              BottomButtonWidget(
                buttonTitle: AppStrings.trackHelperLocation,
                buttonBGColor: AppColors.black,
                onPressed: onPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
