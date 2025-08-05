import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_strings.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_text_styles.dart';

class CallCustomerWidget extends StatelessWidget {
  final String phoneNumber;
  const CallCustomerWidget({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await AppUtils.makePhoneCall(phoneNumber),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sw),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              AppStrings.callCustomer.toUpperCase(),
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 16.fs,
                fontWeight: FontWeight.w500,
                color: AppColors.appOrange,
              ),
              textAlign: TextAlign.left,
            ),
            SvgPicture.asset(
              AppAssets.callIconSvg,
              height: 18.sh,
              color: AppColors.appOrange,
            )
          ],
        ),
      ),
    );
  }
}
