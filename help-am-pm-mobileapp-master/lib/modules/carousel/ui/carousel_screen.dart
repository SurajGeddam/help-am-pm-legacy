import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_models/key_value_model.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_mock_list.dart';
import '../../../utils/app_strings.dart';
import '../../login/ui/login_screen.dart';
import 'widgets/card_widget.dart';
import 'widgets/top_widget.dart';

class CarouselScreen extends StatelessWidget {
  static const String routeName = "/CarouselScreen";
  final String keyValue;

  const CarouselScreen({
    Key? key,
    required this.keyValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      isDividerShow: false,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: AppUtils.deviceHeight,
              width: AppUtils.deviceWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TopWidget(onPressed: () => navigateTo(context)),
                  Expanded(
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: AppMockList.logoList.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          KeyValueModel item = AppMockList.logoList[index];
                          return CardWidget(item: item);
                        }),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: 24.sh, left: 20.sw, right: 20.sw),
              child: BottomButtonWidget(
                buttonTitle: AppStrings.continueString,
                buttonBGColor: AppColors.black,
                onPressed: () => navigateTo(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  navigateTo(BuildContext context) {
    Navigator.pushNamed(
      context,
      LoginScreen.routeName,
      arguments: keyValue,
    );
  }
}
