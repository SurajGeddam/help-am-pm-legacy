import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_models/card_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';

class CreditCardWidget extends StatelessWidget {
  final CardModel cardObj;

  const CreditCardWidget({
    Key? key,
    required this.cardObj,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 32.sh, left: 22.sw),
            child: Text(
              cardObj.cardNumber,
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 20.fs,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 52.sh, left: 22.sw),
            child: Text(
              cardObj.ddyy,
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 16.fs,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.sh, left: 22.sw),
            child: Text(
              cardObj.cardHolderName.toUpperCase(),
              style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 16.fs,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
              ),
              textAlign: TextAlign.left,
            ),
          )
        ],
      ),
    );
  }
}
