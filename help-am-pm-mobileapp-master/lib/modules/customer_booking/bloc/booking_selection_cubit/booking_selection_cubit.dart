import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_constant.dart';

import '../../../../utils/app_utils.dart';
import '../../../onboarding/model/category_model/api/category_model.dart';
import '../../model/service_charge_model.dart';

enum BookingSelectionState { initial }

class BookingSelectionCubit extends Cubit<BookingSelectionState> {
  BookingSelectionCubit() : super(BookingSelectionState.initial);

  ServiceChargeModel calculateTimePrice(CategoryModel? categoryModel) {
    double displayPrice = 0.0;
    String currencySymbol = AppConstants.dollorSign;

    List<Timeslots> timeslots = categoryModel?.timeslots ?? [];
    Timeslots? selectedTimeslot;

    if (timeslots.isNotEmpty) {
      for (var obj in timeslots) {
        int startHours = int.parse(obj.startTime!.split(":")[0]);
        int endHours = int.parse(obj.endTime!.split(":")[0]);

        DateTime currentTime = DateTime.now();
        DateTime startTime = DateTime(currentTime.year, currentTime.month,
            currentTime.day, startHours, 0, 0, 0);
        DateTime endTime = DateTime(currentTime.year, currentTime.month,
            currentTime.day, endHours - 1, 55, 59, 0);

        if (obj.name?.compareTo("Night Hours") == 0) {
          endTime = DateTime(currentTime.year, currentTime.month,
              currentTime.day + 1, endHours - 1, 55, 59, 0);

          if (currentTime.hour >= 0 && currentTime.hour < 9) {
            startTime = DateTime(
              currentTime.year,
              currentTime.month,
              currentTime.day - 1,
              startTime.hour,
              startTime.minute,
              startTime.second,
            );
          }
        }

        // Check in which timeslot current time lies
        if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
          selectedTimeslot = obj;
          break;
        }
      }

      if (selectedTimeslot != null && selectedTimeslot.pricing != null) {
        currencySymbol = AppUtils.getCurrencySymbol(
            getDefaultStringValue(selectedTimeslot.pricing?.currency));
        if (categoryModel?.residentialService ?? false) {
          displayPrice = selectedTimeslot.pricing?.residentialPrice ?? 0.0;
        } else if (categoryModel?.commercialService ?? false) {
          displayPrice = selectedTimeslot.pricing?.commercialPrice ?? 0.0;
        }
      }
    }
    return ServiceChargeModel(
      displayPrice: displayPrice,
      currencySymbol: currencySymbol,
      selectedTimeSlot: selectedTimeslot,
    );
  }

  ServiceChargeModel showTimePriceForSchedule(
    Timeslots timeSlot,
    CategoryModel categoryModel,
  ) {
    double displayPrice = 0.0;
    String currencySymbol = AppConstants.dollorSign;

    if (timeSlot.pricing != null) {
      currencySymbol = AppUtils.getCurrencySymbol(
          getDefaultStringValue(timeSlot.pricing?.currency));

      if (categoryModel.residentialService ?? false) {
        displayPrice = timeSlot.pricing?.residentialPrice ?? 0.0;
      } else if (categoryModel.commercialService ?? false) {
        displayPrice = timeSlot.pricing?.commercialPrice ?? 0.0;
      }
    }
    return ServiceChargeModel(
      displayPrice: displayPrice,
      currencySymbol: currencySymbol,
    );
  }
}
