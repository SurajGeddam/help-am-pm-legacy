import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_colors.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../utils/app_text_styles.dart';

class BottomButtonWidget extends StatelessWidget {
  final String buttonTitle;
  final TextStyle? buttonTitleStyle;
  final Color? buttonBGColor;
  final String? imageOnButton;
  final bool isImageShow;
  final VoidCallback? onPressed;
  final bool isOutlineBtn;
  final bool isSvg;
  final bool isDisable;

  const BottomButtonWidget({
    Key? key,
    required this.buttonTitle,
    this.buttonTitleStyle,
    this.buttonBGColor,
    this.imageOnButton,
    this.isImageShow = false,
    this.onPressed,
    this.isOutlineBtn = false,
    this.isSvg = false,
    this.isDisable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisable ? null : onPressed,
      child: SizedBox(
        height: 48.sw,
        width: AppUtils.deviceWidth,
        child: !isSvg
            ? Container(
                height: 48.sh,
                width: AppUtils.deviceWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    opacity: isDisable ? 0.5 : 1.0,
                    image: ExactAssetImage(isOutlineBtn
                        ? AppAssets.cornerSubtractOutlinePng
                        : AppAssets.cornerSubtractFilledPng),
                    fit: BoxFit.fill,
                  ),
                ),
                alignment: Alignment.center,
                child: isImageShow
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            buttonTitle,
                            style: buttonTitleStyle ??
                                AppTextStyles.defaultTextStyle.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.fs,
                                ),
                          ),
                          SizedBox(width: 6.sw),
                          SvgPicture.asset(
                            imageOnButton ?? AppAssets.nextArrowSvgIcon,
                            width: 16.sw,
                            height: 10.sh,
                          )
                        ],
                      )
                    : Text(
                        buttonTitle,
                        style: buttonTitleStyle ??
                            AppTextStyles.defaultTextStyle.copyWith(
                              color: (buttonBGColor == AppColors.black)
                                  ? AppColors.white
                                  : AppColors.black
                                      .withOpacity(isDisable ? 0.3 : 1.0),
                              fontWeight: FontWeight.w500,
                              fontSize: 16.fs,
                            ),
                      ),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    isOutlineBtn
                        ? AppAssets.cornerSubtractOutlineSvg
                        : AppAssets.cornerSubtractFilledSvg,
                    width: MediaQuery.of(context).size.width,
                    color: isOutlineBtn
                        ? null
                        : (buttonBGColor ?? AppColors.appGrey),
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                  ),
                  isImageShow
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              buttonTitle,
                              style: buttonTitleStyle ??
                                  AppTextStyles.defaultTextStyle.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.fs,
                                  ),
                            ),
                            SizedBox(width: 6.sw),
                            SvgPicture.asset(
                              imageOnButton ?? AppAssets.nextArrowSvgIcon,
                              width: 16.sw,
                              height: 10.sh,
                            )
                          ],
                        )
                      : Text(
                          buttonTitle,
                          style: buttonTitleStyle ??
                              AppTextStyles.defaultTextStyle.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.fs,
                              ),
                        ),
                ],
              ),
      ),
    );
  }
}
