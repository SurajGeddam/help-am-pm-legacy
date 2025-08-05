import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../core_components/common_widgets/app_image_note_dialog.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';
import 'service_amount_detail_widget.dart';

class ServiceInfoWidget extends StatelessWidget {
  final Quotes scheduleOrder;

  const ServiceInfoWidget({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          useSafeArea: false,
          builder: (_) => AppImageNoteDialog(quotes: scheduleOrder),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: 24.sh, left: 20.sh, right: 20.sh),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  AppStrings.serviceInfo,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 20.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                if (scheduleOrder.imagePath.isNotEmpty)
                  Icon(
                    Icons.image,
                    color: AppColors.appYellow,
                    size: 24.sh,
                  )
              ],
            ),
            SizedBox(height: 4.sh),
            Text(
              "${AppUtils.getDatedMMM(scheduleOrder.serviceDate)} ${AppUtils.getDateHhMmA(scheduleOrder.serviceDate)}",
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 16.fs,
                fontWeight: FontWeight.w500,
                color: AppColors.textDarkColorOnForm,
              ),
            ),
            SizedBox(height: 8.sh),
            Text(
              scheduleOrder.serviceDescription,
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 12.fs,
              ),
              textAlign: TextAlign.left,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            ServiceAmountDetailWidget(scheduleOrder: scheduleOrder),
          ],
        ),
      ),
    );
  }
}
