import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_colors.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../core_components/common_models/key_value_model.dart';
import '../../../../utils/app_mock_list.dart';

class HorizontalStepperWidget extends StatelessWidget {
  final List<KeyValueModel> userInputDetailList;

  const HorizontalStepperWidget({
    Key? key,
    required this.userInputDetailList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: userInputDetailList.length,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext ctx, int index) {
          return SizedBox(
            height: double.infinity,
            width: (AppUtils.deviceWidth - 40) /
                AppMockList.userInputDetailList.length,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  userInputDetailList[index].displayString,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 10.fs,
                    fontWeight: FontWeight.w400,
                    color: userInputDetailList[index].isSelected
                        ? AppColors.black
                        : AppColors.textColorOnForm,
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        height: 1.sh,
                        color: (index == 0)
                            ? AppColors.transparent
                            : AppColors.appOrange,
                      ),
                    ),
                    Container(
                      width: 20.sw,
                      height: 20.sh,
                      decoration: BoxDecoration(
                        color: userInputDetailList[index].isSelected
                            ? AppColors.appOrange
                            : AppColors.appThinGrey,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        (index + 1).toString(),
                        style: AppTextStyles.defaultTextStyle.copyWith(
                          fontSize: 14.fs,
                          fontWeight: FontWeight.w400,
                          color: userInputDetailList[index].isSelected
                              ? AppColors.white
                              : AppColors.appLightMediumGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        height: 1.sh,
                        color: (index < userInputDetailList.length - 1)
                            ? AppColors.appOrange
                            : AppColors.transparent,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
