import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';

class OSTopTextWidget extends StatelessWidget {
  final bool isProviderReached;
  final Quotes? quotes;

  const OSTopTextWidget({
    Key? key,
    this.isProviderReached = false,
    this.quotes,
  }) : super(key: key);

  /*String getTimeOverDistance(Quotes quotes) {
    LatLng dis1 = LatLng(
        quotes.customerAddress!.latitude, quotes.customerAddress!.longitude);
    LatLng dis2 = LatLng(
        quotes.customerAddress!.latitude, quotes.customerAddress!.longitude);
    double value =
        AppUtils.calculateDistanceByLatLng(latLng1: dis1, latLng2: dis2);
    double reachTime = value / AppConstants.speed;
    return reachTime.round().toString();
  }*/

  String displayETAString(String? eta) {
    if (eta == null) {
      return AppStrings.emptyString;
    } else {
      String displayString = AppStrings.emptyString;
      String hr = eta.split(":")[0];
      String min = eta.split(":")[1];
      if (hr == "00") {
        displayString = "$min ${AppStrings.mins}";
      } else {
        displayString = "$hr ${AppStrings.hrs} $min ${AppStrings.mins}";
      }
      return displayString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          isProviderReached
              ? AppStrings.yourServiceHasBeenArrived
                  .replaceAll("SERVICE", quotes!.categoryName)
              //: "${quotes?.eta} ${AppStrings.minutes}",
              : displayETAString(quotes?.eta),
          style: AppTextStyles.defaultTextStyle.copyWith(
            fontSize: 26.fs,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.sh),
        if (!isProviderReached)
          Text(
            AppStrings.estimateTimeOfArrival,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 14.fs,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
