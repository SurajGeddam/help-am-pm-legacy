import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';

class CalendarCarouselWidget extends StatelessWidget {
  final DateTime? currentDate;
  final Color? currentDateColor;
  final Function onDayPressed;

  const CalendarCarouselWidget({
    Key? key,
    this.currentDate,
    this.currentDateColor,
    required this.onDayPressed,
    required DateTime maxSelectedDate,
    required DateTime minSelectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: 20.sw),
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) =>
            onDayPressed(date, events),
        thisMonthDayBorderColor: AppColors.transparent,
        weekFormat: false,
        height: 325.sh,
        minSelectedDate: DateTime.now().subtract(const Duration(days: 1)),
        maxSelectedDate: DateTime(2100),
        selectedDateTime: currentDate,
        iconColor: AppColors.appOrange,
        todayBorderColor: AppColors.dividerColor,
        headerTextStyle: AppTextStyles.defaultTextStyle.copyWith(
          fontSize: 16.fs,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        selectedDayButtonColor: AppColors.appOrange,
        todayTextStyle: const TextStyle(color: AppColors.black),
        todayButtonColor: currentDateColor ?? AppColors.appOrange,
        weekdayTextStyle: TextStyle(color: AppColors.appOrange),
        weekendTextStyle: TextStyle(color: AppColors.appMediumGrey),
      ),
    );
  }
}
