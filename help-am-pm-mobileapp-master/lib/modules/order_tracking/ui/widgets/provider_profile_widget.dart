import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_strings.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/app_utils.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';

class ProviderProfileWidget extends StatelessWidget {
  final Quotes? quotes;
  const ProviderProfileWidget({
    Key? key,
    this.quotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.deviceWidth,
      padding: EdgeInsets.symmetric(vertical: 20.sh),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          stops: [0.0, 1.0],
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          tileMode: TileMode.repeated,
          colors: [
            Color(0xFFFBB034),
            Color(0xFFFFDD00),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 68.sh,
            width: 68.sw,
            margin: EdgeInsets.only(left: 20.sw, right: 12.sw),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.textDarkColorOnForm,
              image: const DecorationImage(
                image: NetworkImage(
                    "https://cdn.pixabay.com/photo/2016/03/26/13/09/workspace-1280538_1280.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  quotes!.quoteProvider?.providerName ?? AppStrings.emptyString,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 16.fs,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 6.sh),
                Text(
                  quotes!.quoteProvider?.uniqueId ?? AppStrings.emptyString,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 12.fs,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
