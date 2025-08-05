import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';
import '../../model/save_address_model/request_body/save_address_req_body_model.dart';

class AddressCardComponentWidget extends StatelessWidget {
  final SaveAddressReqBodyModel address;
  // final VoidCallback onPressed;

  const AddressCardComponentWidget({
    Key? key,
    required this.address,
    // required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.sh, bottom: 8.sh),
            child: Text(
              address.name,
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 16.fs,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ),
          /*Text(
            "${AppStrings.phoneNumber} ${address.phoneNumber}",
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 14.fs,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),*/
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.sh),
            child: Text(
              "${address.building} ${address.street}, "
              "${address.district}\n${address.county} "
              "${address.zipcode}\n${address.country}",
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 14.fs,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
