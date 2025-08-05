import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';
import '../../model/save_address_model/request_body/save_address_req_body_model.dart';

class AddressCardWidget extends StatelessWidget {
  final SaveAddressReqBodyModel address;
  final Function onSelect;
  final VoidCallback onPressed;
  final bool isFromChangeLocation;

  const AddressCardWidget({
    Key? key,
    required this.address,
    required this.onSelect,
    required this.onPressed,
    this.isFromChangeLocation = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.sh, horizontal: 10.sh),
        elevation: 8.0,
        child: Container(
          padding: EdgeInsets.all(20.sh),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // _selectionWidget(),
              if (address.name.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8.sh, bottom: 4.sh),
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
        ),
      ),
    );
  }

  /*Widget _selectionWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        address.isDefault
            ? Container(
                height: 20.sh,
                padding: EdgeInsets.symmetric(horizontal: 20.sw),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: AppColors.appYellow,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppStrings.defaultString,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 12.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              )
            : const Offstage(),
        const Spacer(),
        isFromChangeLocation
            ? const Offstage()
            : InkWell(
                onTap: () => onSelect(address),
                child: SvgPicture.asset(
                  address.isDefault
                      ? AppAssets.selectedCircleIconSvg
                      : AppAssets.circleIconSvg,
                  height: 16.sh,
                  width: 16.sw,
                ),
              )
      ],
    );
  }*/
}
