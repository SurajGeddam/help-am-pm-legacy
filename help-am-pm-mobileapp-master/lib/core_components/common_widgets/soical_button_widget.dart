import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_colors.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../utils/app_text_styles.dart';

class SocialButtonWidget extends StatelessWidget {
  final String buttonTitle;
  final Color? buttonBGColor;
  final String? imageOnButton;
  final bool isSvgImage;
  final bool isImageShow;
  final VoidCallback? onPressed;

  const SocialButtonWidget({
    Key? key,
    required this.buttonTitle,
    this.buttonBGColor,
    this.imageOnButton,
    this.isSvgImage = false,
    this.isImageShow = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 55.sw,
        width: AppUtils.deviceWidth,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.dividerColor,
              blurRadius: 16.r,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.cornerSubtractFilledSvg,
              width: AppUtils.deviceWidth,
              color: buttonBGColor ?? AppColors.appGrey,
              fit: BoxFit.fill,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 24.sw),
                child: isSvgImage
                    ? SvgPicture.asset(
                        imageOnButton ?? AppAssets.nextArrowSvgIcon,
                        width: 16.sw,
                        height: 10.sh,
                      )
                    : Image.asset(
                        imageOnButton ?? AppAssets.gmailIcon,
                        width: 28.sw,
                        height: 28.sh,
                      ),
              ),
            ),
            Text(
              buttonTitle,
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14.fs,
                color: AppColors.lightBlackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
