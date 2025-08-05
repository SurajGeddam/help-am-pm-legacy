import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../core_components/common_widgets/app_dotted_line_widget.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../core/services/bloc/previous_location.dart';
import '../../../../utils/app_strings.dart';
import '../../../address/model/save_address_model/request_body/save_address_req_body_model.dart';
import '../../model/api/new_order_list_model.dart';

class SourceDestinationRoadmapWidget extends StatelessWidget {
  final Quotes scheduleOrder;

  const SourceDestinationRoadmapWidget({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SaveAddressReqBodyModel? customerAddress = scheduleOrder.customerAddress;

    String customerAddressDes = (customerAddress == null)
        ? AppStrings.emptyString
        : '${customerAddress.building} ${customerAddress.street} ${customerAddress.district} '
            '\n${customerAddress.county} ${customerAddress.zipcode} ${customerAddress.country}';

    return Padding(
      padding:
          EdgeInsets.only(top: 20.sh, left: 16.sw, right: 16.sw, bottom: 6.sh),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _childWidget(
            image: AppAssets.sourceLocationIconSvg,
            address: getDefaultStringValue(
                PreviousLocation.instance.previousLocationDescription),
            locationName: getDefaultStringValue(
                PreviousLocation.instance.previousLocationName),
            isShowDottedLine: true,
          ),
          _childWidget(
            image: AppAssets.destinationLocationIconSvg,
            address: customerAddressDes,
            locationName: getDefaultStringValue(customerAddress?.name),
          ),
        ],
      ),
    );
  }

  Widget _childWidget({
    required String image,
    required String address,
    required String locationName,
    bool isShowDottedLine = false,
  }) {
    return Container(
      color: AppColors.transparent,
      height: 64.sh,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 24.sh,
                width: 24.sw,
                child: SvgPicture.asset(
                  image,
                  color: AppColors.appOrange,
                  fit: BoxFit.contain,
                ),
              ),
              if (isShowDottedLine)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.sh),
                    child: CustomPaint(
                      painter: AppDottedLineWidget(
                        color: AppColors.appDarkGrey,
                        isDottedLineVertical: true,
                        dashHeight: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.sw),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  address,
                  maxLines: 2,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    color: AppColors.black,
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3.sh),
                Text(
                  locationName,
                  maxLines: 4,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    color: AppColors.textMediumColorOnForm,
                    fontSize: 12.fs,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
