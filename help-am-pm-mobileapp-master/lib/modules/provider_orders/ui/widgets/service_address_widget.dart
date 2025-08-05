import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpampm/modules/provider_new_order/model/api/new_order_list_model.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../address/model/save_address_model/request_body/save_address_req_body_model.dart';

class ServiceAddressWidget extends StatelessWidget {
  final Quotes scheduleOrder;

  const ServiceAddressWidget({
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

    return Container(
      padding: EdgeInsets.only(top: 30.sh, left: 20.sw, right: 20.sw),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 12.sw),
            child: SvgPicture.asset(
              AppAssets.locationIconSvg,
              height: 20.sh,
              color: AppColors.appYellow,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: customerAddressDes,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 18.fs,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "\n${getDefaultStringValue(customerAddress?.name)}",
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      fontSize: 15.fs,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorOnForm,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.sw),
            width: 1.sw,
            height: 60.sw,
            color: AppColors.dividerColor,
          ),
          GestureDetector(
            onTap: () {
              LatLng latLng = LatLng(
                  getDefaultDoubleValue(customerAddress?.latitude),
                  getDefaultDoubleValue(customerAddress?.longitude));
              AppUtils.navigateToMap(latLng);
            },
            child: SizedBox(
              width: 80.sw,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.navigationIconSvg,
                    height: 28.sh,
                    color: AppColors.appYellow,
                  ),
                  SizedBox(height: 12.sh),
                  Text(
                    AppStrings.navigate,
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      fontSize: 14.fs,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
