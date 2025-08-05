import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class AlertDialogForDeleteWidget extends StatelessWidget {
  final VoidCallback? onPressedOk;
  final VoidCallback? onPressedCancel;

  const AlertDialogForDeleteWidget({
    Key? key,
    this.onPressedOk,
    this.onPressedCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.sw),
          padding: EdgeInsets.symmetric(horizontal: 20.sw, vertical: 40.sh),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_forever,
                color: AppColors.red,
                size: 48.sh,
              ),
              SizedBox(height: 16.sh),
              Text(
                AppStrings.deleteMyAccountMsg,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 18.fs,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.sh),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: BottomButtonWidget(
                      isSvg: true,
                      buttonTitle: AppStrings.cancel,
                      buttonBGColor: AppColors.black,
                      onPressed: onPressedCancel,
                    ),
                  ),
                  SizedBox(width: 32.sh),
                  Expanded(
                    child: BottomButtonWidget(
                      isSvg: true,
                      buttonTitle: AppStrings.delete,
                      buttonBGColor: AppColors.red,
                      onPressed: onPressedOk,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
