import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_mock_list.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import 'order_history_tab_widget.dart';
import 'order_schedule_tab_widget.dart';

class ProviderOrdersListScreen extends StatefulWidget {
  static const String routeName = "/ProviderOrdersListScreen";

  const ProviderOrdersListScreen({Key? key}) : super(key: key);

  @override
  State<ProviderOrdersListScreen> createState() =>
      _ProviderOrdersListScreenState();
}

class _ProviderOrdersListScreenState extends State<ProviderOrdersListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.orders,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 45.sh,
            color: AppColors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.black,
              labelStyle: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 14.fs,
                fontWeight: FontWeight.w400,
              ),
              unselectedLabelColor: AppColors.appMediumGrey,
              physics: const NeverScrollableScrollPhysics(),
              indicatorColor: AppColors.black,
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              indicatorWeight: 2.sh,
              tabs: AppMockList.ordersTabs,
            ),
          ),
          // tab bar view here
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                OrderHistoryTabWidget(),
                OrderScheduleTabWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
