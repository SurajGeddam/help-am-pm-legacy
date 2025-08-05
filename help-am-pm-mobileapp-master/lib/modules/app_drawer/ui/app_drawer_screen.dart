import 'package:flutter/material.dart';
import 'package:helpampm/core_components/common_widgets/app_loading_widget.dart';
import 'package:helpampm/utils/app_constant.dart';

import '../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/app_utils.dart';
import '../../login/model/login_model/auth_token_model.dart';
import 'widgets/drawer_header_widget.dart';
import 'widgets/drawer_items_list_widget.dart';

class AppDrawerScreen extends StatefulWidget {
  static const String routeName = "/AppDrawerScreen";

  const AppDrawerScreen({Key? key}) : super(key: key);

  @override
  State<AppDrawerScreen> createState() => _AppDrawerScreenState();
}

class _AppDrawerScreenState extends State<AppDrawerScreen> {
  SharedPreferenceHelper preference = SharedPreferenceHelper();
  UserDetailsDto? userDetailsDto;

  Future<void> getData() async {
    String str =
        preference.getStringValue(SharedPreferenceConstants.userDetailsDto);

    if (!isEmpty(str)) {
      userDetailsDto = await preference.getUserDetailsDto();
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.myAccount,
      isDividerShow: false,
      child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const DrawerHeaderWidget(),
                  const Expanded(child: DrawerItemsListWidget()),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text(
                      "${AppStrings.version}: ${AppConstants.appVersion}",
                      style: AppTextStyles.defaultTextStyle.copyWith(
                        fontSize: 12.fs,
                      ),
                    ),
                  ),
                ],
              );
            }
            return const AppLoadingWidget();
          }),
    );
  }
}
