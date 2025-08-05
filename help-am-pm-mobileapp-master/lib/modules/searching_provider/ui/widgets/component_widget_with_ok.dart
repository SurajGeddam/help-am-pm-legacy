import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../customer_home/ui/customer_home_screen.dart';

class ComponentWidgetWithOkButton extends StatelessWidget {
  const ComponentWidgetWithOkButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sh),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.weCareForYour,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 14.fs,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            maxLines: 1,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 14.sh),
          Text(
            AppStrings.waitMessageForCustomer,
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontSize: 14.fs,
              fontWeight: FontWeight.w300,
              color: AppColors.black,
            ),
            maxLines: 2,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Center(
              child: BottomButtonWidget(
                buttonTitle: AppStrings.ok,
                buttonBGColor: AppColors.black,
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    CustomerHomeScreen.routeName,
                    (Route<dynamic> route) => false),
              ),
            ),
          )
        ],
      ),
    );
  }
}
