import 'package:flutter/material.dart';
import 'package:helpampm/core_components/common_models/key_value_model.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_mock_list.dart';
import 'package:helpampm/utils/app_strings.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../../utils/app_colors.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../login/ui/register_screen.dart';
import 'widgets/options_list_view_widget.dart';

class OptionsScreen extends StatefulWidget {
  static const String routeName = "/OptionsScreen";

  const OptionsScreen({Key? key}) : super(key: key);

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  List<KeyValueModel> list = [];
  KeyValueModel? selectedUser;

  resetData() {
    list = AppMockList.optionScreenList;
    for (int i = 0; i < list.length; i++) {
      list[i].isSelected = false;
    }
  }

  @override
  void initState() {
    super.initState();
    resetData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBarBgColor: AppColors.white,
      scaffoldBgColor: AppColors.white,
      isDividerShow: false,
      isBackShow: true,
      child: Center(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            Image.asset(
              AppAssets.appLogo,
              height: 86.sh,
              width: 86.sw,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 42.sh),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 43.sh),
              margin: EdgeInsets.all(20.sh),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                gradient: const LinearGradient(
                  stops: [0.0, 1.0],
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,
                  tileMode: TileMode.repeated,
                  colors: [
                    Color(0xFF4A4A4D),
                    Color(0xFF0D0C2B),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 26.sh),
                  Text(
                    AppStrings.whoAreYou,
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      fontSize: 22.fs,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                  OptionListViewWidget(
                    list: list,
                    callBack: (value) {
                      setState(() => selectedUser = value);
                    },
                  ),
                  BottomButtonWidget(
                    isSvg: true,
                    buttonTitle: AppStrings.next,
                    buttonBGColor: (selectedUser == null)
                        ? AppColors.appGrey
                        : AppColors.appYellow,
                    isImageShow: true,
                    imageOnButton: AppAssets.nextArrowSvgIcon,
                    onPressed: (selectedUser == null)
                        ? null
                        : () => Navigator.pushNamed(
                            context, RegisterScreen.routeName,
                            arguments: selectedUser?.key),
                  ),
                  SizedBox(height: 48.sh),
                  /*Text(
                    "${AppStrings.version}: ${AppConstants.appVersion}",
                    style: TextStyle(
                      fontSize: 12.fs,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: 16.sh),*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
