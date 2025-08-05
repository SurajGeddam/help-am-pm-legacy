import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_styles.dart';

class AppDialogBox extends StatelessWidget {
  final bool isHorizontalBtn;
  final String title;
  final String? content;
  final String? btn1Text;
  final String? btn2Text;
  final String btn3Text;

  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final TextStyle? btn1TextStyle;
  final TextStyle? btn2TextStyle;
  final TextStyle? btn3TextStyle;

  final VoidCallback? onPressedBtn1;
  final VoidCallback? onPressedBtn2;
  final VoidCallback? onPressedBtn3;

  const AppDialogBox({
    Key? key,
    this.isHorizontalBtn = true,
    required this.title,
    this.content,
    required this.btn1Text,
    this.btn2Text = AppStrings.emptyString,
    this.btn3Text = AppStrings.emptyString,
    this.btn1TextStyle,
    this.titleStyle,
    this.contentStyle,
    this.btn2TextStyle,
    this.btn3TextStyle,
    required this.onPressedBtn1,
    this.onPressedBtn2,
    this.onPressedBtn3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: AppColors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppColors.dividerColor,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 18.sh,
                left: 16.sw,
                right: 16.sw,
              ),
              child: Text(
                title,
                style: titleStyle ??
                    AppTextStyles.defaultTextStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.fs,
                      color: AppColors.black,
                      height: 1.25,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.sh, left: 16.sw, right: 16.sw),
              child: Text(
                content!,
                style: contentStyle ??
                    AppTextStyles.defaultTextStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.fs,
                      color: AppColors.black,
                      height: 1.25,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 18.sh),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    height: 0.5,
                    color: AppColors.dividerColor,
                  ),
                  isHorizontalBtn
                      ? _horizontalBtnContainer()
                      : _verticalBtnContainer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalBtnContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          key: const Key("BUTTON1_TEXT_KEY"),
          onTap: onPressedBtn1,
          child: SizedBox(
              height: 44.sh,
              child: Center(
                child: Text(
                  btn1Text!,
                  style: btn1TextStyle ??
                      AppTextStyles.defaultTextStyle.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 16.fs,
                        color: AppColors.hyperLinkBlue,
                      ),
                ),
              )),
        ),
        Visibility(
          visible: btn2Text!.isNotEmpty,
          child: Container(
            height: 0.3,
            color: AppColors.dividerColor,
          ),
        ),
        Visibility(
          visible: btn2Text!.isNotEmpty,
          child: GestureDetector(
            key: const Key("BTN_2_TEXT"),
            onTap: onPressedBtn2,
            child: SizedBox(
              height: 44.0,
              child: Center(
                  child: Text(
                btn2Text!,
                style: btn2TextStyle ??
                    AppTextStyles.defaultTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.fs,
                      color: AppColors.hyperLinkBlue,
                    ),
              )),
            ),
          ),
        ),
        Visibility(
          visible: btn3Text.isNotEmpty,
          child: Container(
            height: 0.3,
            color: AppColors.dividerColor,
          ),
        ),
        Visibility(
          visible: btn3Text.isNotEmpty,
          child: GestureDetector(
            key: const Key("BTN_3_TEXT"),
            onTap: onPressedBtn3,
            child: SizedBox(
              height: 44.sh,
              child: Center(
                child: Text(
                  btn3Text,
                  style: btn3TextStyle ??
                      AppTextStyles.defaultTextStyle.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 16.fs,
                        color: AppColors.hyperLinkBlue,
                      ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _horizontalBtnContainer() {
    return SizedBox(
      height: 44.sh,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: GestureDetector(
            key: const Key("BUTTON1_TEXT_KEY"),
            onTap: onPressedBtn1,
            child: Center(
                child: Text(
              btn1Text!,
              style: btn1TextStyle ??
                  AppTextStyles.defaultTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.fs,
                    color: AppColors.hyperLinkBlue,
                  ),
            )),
          )),
          Visibility(
            visible: btn2Text!.isNotEmpty,
            child: Container(
              width: 0.3,
              color: AppColors.dividerColor,
            ),
          ),
          Visibility(
            visible: btn2Text!.isNotEmpty,
            child: Expanded(
                child: GestureDetector(
              key: const Key("BTN_2_TEXT"),
              onTap: onPressedBtn2,
              child: Center(
                  child: Text(
                btn2Text!,
                style: btn2TextStyle ??
                    AppTextStyles.defaultTextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.fs,
                      color: AppColors.dividerColor,
                    ),
              )),
            )),
          ),
        ],
      ),
    );
  }
}
