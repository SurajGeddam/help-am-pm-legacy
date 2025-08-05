import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_mock_list.dart';
import '../../../../../utils/app_text_styles.dart';

class OperationsListWidget extends StatelessWidget {
  const OperationsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.deviceWidth,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 26.sh),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 20.sw,
        runSpacing: 20.sw,
        children: AppMockList.providerOperationsList
            .map((e) => contentWidget(
                  context: context,
                  routeName: e.routeName,
                  key: e.key,
                  value: e.value,
                ))
            .toList(),
      ),
    );
  }

  Widget contentWidget(
      {required BuildContext context,
      required routeName,
      required String key,
      required String value}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName,
          arguments: AppMockList.userProfile),
      child: Container(
        height: 110.sh,
        width: AppUtils.deviceWidth * 0.4,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.appMediumGrey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SvgPicture.asset(
                key,
                fit: BoxFit.contain,
                height: 38.sh,
                color: AppColors.appOrange,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMediumColorOnForm,
                  ),
                ),
                SizedBox(width: 8.sw),
                SvgPicture.asset(
                  AppAssets.backIconSvg,
                  fit: BoxFit.contain,
                  height: 10.sh,
                  color: AppColors.textMediumColorOnForm,
                ),
              ],
            ),
            SizedBox(height: 12.sh),
          ],
        ),
      ),
    );
  }
}
