import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_styles.dart';

class AppCheckBoxWidget extends StatefulWidget {
  final Widget? customWidget;
  final String text;
  final TextStyle? textStyle;
  final Function? onTap;
  final EdgeInsetsGeometry? padding;

  const AppCheckBoxWidget({
    Key? key,
    this.customWidget,
    this.text = AppStrings.emptyString,
    this.textStyle,
    this.onTap,
    this.padding,
  }) : super(key: key);

  @override
  State<AppCheckBoxWidget> createState() => _AppCheckBoxWidgetState();
}

class _AppCheckBoxWidgetState extends State<AppCheckBoxWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isSelected = !isSelected);
        widget.onTap!(isSelected);
      },
      child: Padding(
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 20.sh),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isSelected
                  ? AppAssets.checkBoxIconSvg
                  : AppAssets.emptyCheckBoxIconSvg,
              height: 20.sh,
              width: 20.sw,
              color: isSelected ? null : AppColors.appDarkGrey,
            ),
            SizedBox(width: 8.sw),
            widget.customWidget ??
                Text(
                  widget.text,
                  style: widget.textStyle ??
                      AppTextStyles.defaultTextStyle.copyWith(
                        fontSize: 14.fs,
                        fontWeight: FontWeight.w300,
                        color: AppColors.appMediumGrey,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          ],
        ),
      ),
    );
  }
}
