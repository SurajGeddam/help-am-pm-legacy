import 'package:flutter/material.dart';
import 'package:helpampm/modules/customer_home/ui/customer_home_screen.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_utils.dart';
import '../../provider_new_order/model/api/new_order_list_model.dart';
import '../../summary/ui/customer_summary_screen.dart';
import 'widgets/os_detail_widget.dart';
import 'widgets/os_top_widget.dart';

class OngoingServiceScreen extends StatelessWidget {
  static const String routeName = "/OngoingServiceScreen";
  final bool isProviderReached;
  final Quotes? quotes;

  const OngoingServiceScreen({
    Key? key,
    this.isProviderReached = false,
    this.quotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      safeAreaTop: false,
      isAppBarShow: false,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 2,
                child: PSTopWidget(
                  isProviderReached: isProviderReached,
                  quotes: quotes,
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  width: AppUtils.deviceWidth,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: OSDetailWidget(
              isProviderReached: isProviderReached,
              quotes: quotes,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: 24.sh, left: 20.sw, right: 20.sw),
              child: BottomButtonWidget(
                buttonTitle:
                    isProviderReached ? AppStrings.checkSummary : AppStrings.ok,
                buttonBGColor: AppColors.black,
                onPressed: () => isProviderReached
                    ? Navigator.of(context).pushNamed(
                        CustomerSummaryScreen.routeName,
                        arguments: quotes)
                    /* /// Todo: for next sprint
                    : Navigator.of(context).pushNamed(
                        OrderTrackingScreen.routeName,
                        arguments: quotes),*/
                    : Navigator.pushNamedAndRemoveUntil(
                        context, CustomerHomeScreen.routeName, (route) => true),
              ),
            ),
          )
        ],
      ),
    );
  }
}
