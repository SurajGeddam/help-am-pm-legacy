import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_widgets/app_text_field_form_widget.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/app_text_styles.dart';

class FindLocationByAddressWidget extends StatelessWidget {
  final TextEditingController addressTextController = TextEditingController();

  FindLocationByAddressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 14.sh),
        Text(
          AppStrings.pleaseEnterYourAddress,
          style: AppTextStyles.defaultTextStyle.copyWith(
            fontSize: 14.fs,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
          maxLines: 1,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 26.sh),
        AppTextFieldFormWidget(
          textController: addressTextController,
          maxLength: 50,
          hintText: AppStrings.enterAddress,
        ),
      ],
    );
  }
}
