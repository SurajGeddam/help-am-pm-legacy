import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../core/services/bloc/previous_location.dart';
import '../../../../utils/app_strings.dart';
import '../../model/api/new_order_list_model.dart';

class ServiceNamePriceDistanceWidget extends StatelessWidget {
  final Quotes scheduleOrder;

  const ServiceNamePriceDistanceWidget({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double distance = AppUtils.calculateDistanceByLatLng(
      latLng1: LatLng(
          getDefaultDoubleValue(PreviousLocation.instance.previousLatitude),
          getDefaultDoubleValue(PreviousLocation.instance.previousLongitude)),
      latLng2: LatLng(
          getDefaultDoubleValue(scheduleOrder.customerAddress?.latitude),
          getDefaultDoubleValue(scheduleOrder.customerAddress?.longitude)),
      isInMeter: false,
    );

    String timeSlot =
        "${AppUtils.showDateHHMM(getDefaultStringValue(scheduleOrder.timeslot?.startTime))} to ${AppUtils.showDateHHMM(getDefaultStringValue(scheduleOrder.timeslot?.endTime))}";
    String currencySymbol = AppUtils.getCurrencySymbol(scheduleOrder.currency);

    return Padding(
      padding: EdgeInsets.all(14.sh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  scheduleOrder.categoryName,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 6.sh),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "${distance.toStringAsFixed(2)} ${AppStrings.kms}",
                      style: AppTextStyles.defaultTextStyle.copyWith(
                        fontSize: 12.fs,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMediumColorOnForm,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.sw),
                      child: SvgPicture.asset(
                        AppAssets.dotIconSvg,
                        color: AppColors.textMediumColorOnForm,
                        fit: BoxFit.contain,
                        width: 6.sw,
                      ),
                    ),
                    Text(
                      timeSlot,
                      style: AppTextStyles.defaultTextStyle.copyWith(
                        fontSize: 12.fs,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMediumColorOnForm,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Text(
            "$currencySymbol${scheduleOrder.totalBill.toStringAsFixed(2)}",
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 20.fs,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
