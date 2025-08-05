import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/app_helper.dart';
import '../../../../utils/app_strings.dart';
import '../../model/provider_log_model/provider_log_model.dart';

class LogsScreen extends StatelessWidget {
  final List<CountModel> list;

  const LogsScreen({
    Key? key,
    required this.list,
  }) : super(key: key);

  String getDisplayValue(CountModel e) {
    String displayString = AppStrings.emptyString;
    if (e.amount ?? false) {
      displayString =
          AppConstants.dollorSign + (e.value ?? AppStrings.emptyString);
    } else {
      double myInt = double.parse(e.value ?? "0.00");
      displayString = myInt.round().toString();
    }

    return displayString;
  }

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? const Offstage()
        : Container(
            width: AppUtils.deviceWidth,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 26.sh),
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 20.sw,
              runSpacing: 20.sw,
              children: list
                  .map((e) => contentWidget(
                        value: getDisplayValue(e),
                        text: (e.text ?? AppStrings.emptyString),
                        bgColor: HexColor(e.bgColor ?? "FFFFFF"),
                      ))
                  .toList(),
            ),
          );
  }

  Widget contentWidget({
    required String value,
    required String text,
    required Color bgColor,
  }) {
    return Container(
      height: 62.sh,
      width: AppUtils.deviceWidth * 0.4,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.sw),
        child: RichText(
          text: TextSpan(
            text: value,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 14.fs,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "\n$text",
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 14.fs,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
