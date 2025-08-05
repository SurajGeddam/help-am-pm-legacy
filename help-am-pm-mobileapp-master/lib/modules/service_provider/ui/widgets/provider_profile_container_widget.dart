import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';

class ProviderProfileContainerWidget extends StatelessWidget {
  final Quotes quotes;

  const ProviderProfileContainerWidget({
    Key? key,
    required this.quotes,
  }) : super(key: key);

  String providerInfo() {
    String infoString = AppStrings.emptyString;

    if (quotes.quoteProvider != null) {
      infoString = quotes.quoteProvider?.uniqueId ?? AppStrings.emptyString;
    }
    return infoString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.sw),
      height: 96.sh,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 84.sw,
            height: 96.sh,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r)),
              child: quotes.quoteProvider!.providerImage.isEmpty
                  ? Container(
                      width: 84.sw,
                      height: 96.sh,
                      color: AppColors.appYellow,
                      alignment: Alignment.center,
                      child: Text(
                        quotes.textOnYellow,
                        style: AppTextStyles.defaultTextStyle.copyWith(
                          fontSize: 24.fs,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Image.memory(
                      AppUtils.convertImage(
                          quotes.quoteProvider!.providerImage),
                      width: 84.sw,
                      height: 96.sh,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sw),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  quotes.providerName,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.sh),
                Text(
                  providerInfo(),
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 12.fs,
                    fontWeight: FontWeight.w300,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
