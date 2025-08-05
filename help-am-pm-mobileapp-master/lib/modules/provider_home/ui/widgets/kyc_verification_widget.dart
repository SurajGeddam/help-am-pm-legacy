import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';

class KYCVerificationWidget extends StatelessWidget {
  const KYCVerificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.sh,
      width: AppUtils.deviceWidth,
      margin: EdgeInsets.only(left: 20.sw, right: 20.sw, top: 20.sh),
      padding: EdgeInsets.symmetric(horizontal: 12.sw),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            AppStrings.yourKYCVerificationIsPending,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 12.fs,
              fontWeight: FontWeight.w500,
              color: AppColors.textMediumColorOnForm,
            ),
          ),
          /*SvgPicture.asset(
            AppAssets.crossCircleSvgIcon,
            height: 20.sh,
            fit: BoxFit.cover,
          )*/
        ],
      ),
    );
  }
}
