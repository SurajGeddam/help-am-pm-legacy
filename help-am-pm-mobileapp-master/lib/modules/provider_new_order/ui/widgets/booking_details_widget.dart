import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_strings.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../core_components/common_widgets/app_dotted_line_widget.dart';
import '../../../../utils/app_text_styles.dart';
import '../../model/api/new_order_list_model.dart';
import 'note_image_widget.dart';
import 'service_name_price_distance_widget.dart';
import 'source_destination_roadmap_widget.dart';

class BookingDetailsWidget extends StatelessWidget {
  final Quotes scheduleOrder;

  const BookingDetailsWidget({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppUtils.deviceWidth,
      margin: EdgeInsets.only(bottom: 110.sh, left: 20.sw, right: 20.sw),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(width: 1.sw, color: AppColors.appGrey),
        boxShadow: [BoxShadow(color: AppColors.dividerColor, blurRadius: 16.r)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ServiceNamePriceDistanceWidget(scheduleOrder: scheduleOrder),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.sw),
            child: CustomPaint(
              painter: AppDottedLineWidget(
                color: AppColors.appDarkGrey,
                isDottedLineVertical: false,
                dashWidth: 2,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.sh, top: 10.sh),
            child: Text(
              AppStrings.serviceInfo,
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 12.fs,
                fontWeight: FontWeight.w500,
                color: AppColors.appOrange,
              ),
            ),
          ),
          NoteImageWidget(scheduleOrder: scheduleOrder),
          Divider(
            height: 1.sh,
            thickness: 1.sh,
            color: AppColors.dividerColor,
          ),
          SourceDestinationRoadmapWidget(scheduleOrder: scheduleOrder),
        ],
      ),
    );
  }
}
