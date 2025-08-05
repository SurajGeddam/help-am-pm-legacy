import 'package:flutter/material.dart';
import 'package:helpampm/modules/customer_booking/model/service_charge_model.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../customer_booking/bloc/booking_selection_cubit/booking_selection_cubit.dart';
import '../../../model/category_model/api/category_model.dart';

class ChooseCategoryTimeSlotWidget extends StatelessWidget {
  final CategoryModel categoryModel;
  final bool isFromScheduleScreen;
  final Function onTap;

  const ChooseCategoryTimeSlotWidget({
    Key? key,
    required this.categoryModel,
    this.isFromScheduleScreen = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Timeslots> list = categoryModel.timeslots ?? [];
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        runSpacing: 16.0,
        spacing: 20.0,
        children: list
            .map((e) => GestureDetector(
                  onTap: () => onTap(e),
                  child: _boxContainerWidget(e, categoryModel),
                ))
            .toList(),
      ),
    );
  }

  Widget _boxContainerWidget(Timeslots timeSlot, CategoryModel categoryModel) {
    String displayPrice = AppStrings.emptyString;
    if (isFromScheduleScreen) {
      ServiceChargeModel serviceCharge = BookingSelectionCubit()
          .showTimePriceForSchedule(timeSlot, categoryModel);
      displayPrice =
          "${serviceCharge.currencySymbol}${serviceCharge.displayPrice.toStringAsFixed(2)}";
    }

    String getTimeInHHmm(String? timeSlotString) {
      if (timeSlotString == null || timeSlotString.isEmpty) {
        return "00:00";
      }
      String value = "";
      value = timeSlotString.split(":")[0];
      value += ":";
      value += timeSlotString.split(":")[1];
      return value;
    }

    return Container(
        height: 118.sh,
        width: 98.sw,
        padding: EdgeInsets.symmetric(horizontal: 16.sw),
        decoration: BoxDecoration(
          color:
              timeSlot.isSelected ? AppColors.appThinOrange : AppColors.white,
          border: Border.all(
            width: 1.sw,
            color: timeSlot.isSelected
                ? AppColors.appOrange
                : AppColors.appThinGrey,
          ),
          borderRadius: BorderRadius.circular(6.r),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (!isFromScheduleScreen)
              Text(
                timeSlot.name ?? AppStrings.emptyString,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 14.fs,
                  fontWeight: FontWeight.w400,
                  color: AppColors.appMediumGrey,
                ),
                textAlign: TextAlign.center,
              ),
            Text(
              "${getTimeInHHmm(timeSlot.startTime)} to ${getTimeInHHmm(timeSlot.endTime)}",
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 14.fs,
                fontWeight: FontWeight.w400,
                color: AppColors.appMediumGrey,
              ),
              textAlign: TextAlign.center,
            ),
            if (isFromScheduleScreen)
              Text(
                displayPrice,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 16.fs,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ));
  }
}
