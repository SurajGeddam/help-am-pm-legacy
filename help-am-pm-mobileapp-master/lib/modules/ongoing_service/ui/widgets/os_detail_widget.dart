import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/app_utils.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';
import 'os_details_component_widget.dart';

class OSDetailWidget extends StatelessWidget {
  final bool isProviderReached;
  final Quotes? quotes;

  const OSDetailWidget({
    Key? key,
    this.isProviderReached = true,
    this.quotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.deviceWidth,
      margin: EdgeInsets.only(
          bottom: AppUtils.deviceHeight * (isProviderReached ? 0.46 : 0.33),
          left: 20.sw,
          right: 20.sw),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(width: 1.sw, color: AppColors.appGrey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 26.sh, bottom: 18.sh, left: 18.sw, right: 18.sw),
            child: _headerWidget(),
          ),
          Divider(
            height: 1.sh,
            thickness: 1.sh,
            color: AppColors.dividerColor,
          ),
          isProviderReached
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 26.sh, horizontal: 16.sh),
                  child: Text(
                    AppStrings.yourServiceManHasBeenArrivedMsg
                        .replaceAll("SERVICE", quotes!.categoryName),
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      fontSize: 12.fs,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : OSDetailsComponentWidget(quotes: quotes),
          SizedBox(height: 36.sh),
        ],
      ),
    );
  }

  Widget _headerWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          AppStrings.orderId,
          style: AppTextStyles.defaultTextStyle.copyWith(
            fontSize: 14.fs,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        Expanded(
          child: Text(
            quotes!.orderNumber,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 14.fs,
              fontWeight: FontWeight.w500,
              color: AppColors.appMediumGrey,
            ),
            textAlign: TextAlign.right,
          ),
        )
      ],
    );
  }
}
