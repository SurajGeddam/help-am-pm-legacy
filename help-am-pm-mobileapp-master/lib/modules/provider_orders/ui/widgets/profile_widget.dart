import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../provider_new_order/model/api/new_order_list_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_text_styles.dart';

class ProfileWidget extends StatelessWidget {
  final Quotes scheduleOrder;

  const ProfileWidget({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sw),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          /*ClipOval(
            child: CachedNetworkImage(
              imageUrl: scheduleOrder.customerProfilePic,
              width: 80.0,
              height: 80.0,
            ),
          ),*/
          CircleAvatar(
            backgroundColor: AppColors.appYellow,
            radius: 24.r,
            backgroundImage: scheduleOrder.customerProfilePic.isNotEmpty
                ? NetworkImage(scheduleOrder.customerProfilePic)
                : null,
            child: SvgPicture.asset(
              AppAssets.userLogoSvgIcon,
              color: AppColors.white,
              width: 16.sw,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 12.sw),
          Expanded(
            child: Text(
              scheduleOrder.customerName,
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 14.fs,
                fontWeight: FontWeight.w500,
                color: AppColors.textDarkColorOnForm,
              ),
            ),
          )
        ],
      ),
    );
  }
}
