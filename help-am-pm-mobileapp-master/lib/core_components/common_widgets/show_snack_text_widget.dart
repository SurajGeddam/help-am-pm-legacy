import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../utils/app_text_styles.dart';

class ShowSnackTextWidget extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;

  const ShowSnackTextWidget({
    Key? key,
    required this.text,
    this.icon,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Container(
            padding: EdgeInsets.only(right: 12.sw),
            child: Icon(
              icon,
              color: iconColor,
              size: 25.sh,
            ),
          ),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: AppTextStyles.defaultTextStyle.copyWith(
              color: textColor,
              fontSize: 12.fs,
            ),
          ),
        ),
      ],
    );
  }
}
