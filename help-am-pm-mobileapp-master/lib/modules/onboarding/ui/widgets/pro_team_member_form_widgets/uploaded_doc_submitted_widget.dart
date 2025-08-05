import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../provider_home/ui/provider_home_screen.dart';

class UploadedDocSubmittedWidget extends StatefulWidget {
  const UploadedDocSubmittedWidget({Key? key}) : super(key: key);

  @override
  State<UploadedDocSubmittedWidget> createState() =>
      _UploadedDocSubmittedWidgetState();
}

class _UploadedDocSubmittedWidgetState
    extends State<UploadedDocSubmittedWidget> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushNamedAndRemoveUntil(
          ProviderHomeScreen.routeName, (Route<dynamic> route) => false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: 318.sh,
          margin: EdgeInsets.symmetric(horizontal: 20.sw),
          padding: EdgeInsets.symmetric(horizontal: 20.sw),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgPicture.asset(
                AppAssets.rightSvgIcon,
                height: 66.sh,
                fit: BoxFit.fill,
              ),
              Text(
                AppStrings.documentsHasBeenSubmitted,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 19.fs,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDarkColorOnForm,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                AppStrings.weWillLookAndApproveItShortly,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 16.fs,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
