import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/modules/contact_us/ui/contact_us_screen.dart';
import 'package:helpampm/modules/help/ui/help_screen.dart';
import 'package:helpampm/modules/setting/setting_screen.dart';
import 'package:helpampm/utils/app_constant.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../../core_components/common_models/key_value_model.dart';
import '../../../../../utils/app_assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_enum.dart';
import '../../../../../utils/app_mock_list.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../address/ui/address_screen.dart';
import '../../../invite/ui/invite_screen.dart';
import '../../../login/ui/change_password.dart';
import '../../../notifications/ui/notifications_screen.dart';
import '../../../payment/ui/card_list_screen.dart';
import '../../../provider_new_order/ui/provider_new_order_list_screen.dart';
import '../../../provider_orders/ui/order_history_tab_widget.dart';
import '../../../provider_orders/ui/order_schedule_tab_widget.dart';
import '../../bloc/logout_cubit.dart';

class DrawerItemsListWidget extends StatefulWidget {
  const DrawerItemsListWidget({Key? key}) : super(key: key);

  @override
  State<DrawerItemsListWidget> createState() => _DrawerItemsListWidgetState();
}

class _DrawerItemsListWidgetState extends State<DrawerItemsListWidget> {
  late LogoutCubit logoutCubit;
  bool loading = false;

  onTap(BuildContext context, String key) {
    switch (key) {
      case AppConstants.newOrder:
        return Navigator.pushNamed(
            context, ProviderNewOrderListScreen.routeName);
      case AppConstants.history:
        return Navigator.pushNamed(context, OrderHistoryTabWidget.routeName,
            arguments: {"isFromDrawer": true});
      case AppConstants.schedule:
        return Navigator.pushNamed(context, OrderScheduleTabWidget.routeName,
            arguments: {"isFromDrawer": true});
      case AppConstants.savedAddress:
        return Navigator.pushNamed(context, AddressScreen.routeName);
      case AppConstants.savedCard:
        return Navigator.pushNamed(context, CardListScreen.routeName);
      case AppConstants.invite:
        return Navigator.pushNamed(context, InviteScreen.routeName);
      case AppConstants.settings:
        return Navigator.pushNamed(context, SettingScreen.routeName);
      case AppConstants.notifications:
        return Navigator.pushNamed(context, NotificationsScreen.routeName);
      case AppConstants.helpNSupport:
        return Navigator.pushNamed(context, HelpScreen.routeName);
      case AppConstants.contactUs:
        return Navigator.pushNamed(context, ContactUsScreen.routeName);
      case AppConstants.changePassword:
        return Navigator.pushNamed(context, ChangePasswordScreen.routeName);
      case AppConstants.logOut:
        return logoutCubit.logoutApi();

      default:
        return Navigator.pop(context);
    }
  }

  @override
  void initState() {
    logoutCubit = BlocProvider.of<LogoutCubit>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<KeyValueModel> drawerList = AppUtils.getIsRoleCustomer()
        ? AppMockList.customerDrawerItemsList
        : AppMockList.providerDrawerItemsList;
    return BlocListener<LogoutCubit, LogoutCubitState>(
      listener: (_, state) {
        if (state == LogoutCubitState.loading) {
          setState(() => loading = true);
        } else if (state == LogoutCubitState.loaded) {
          setState(() => loading = false);
        }
      },
      child: Stack(
        children: [
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: drawerList.length,
            separatorBuilder: (BuildContext ctx, int index) {
              return Divider(
                height: 1.sh,
                thickness: 1.sh,
                color: AppColors.dividerColor,
              );
            },
            itemBuilder: (BuildContext ctx, int index) {
              KeyValueModel obj = drawerList[index];
              bool isLogoutWidget = (obj.key.toUpperCase() ==
                  DrawerType.logOut.type.toUpperCase());

              return GestureDetector(
                onTap: () => onTap(context, obj.key),
                child: AbsorbPointer(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.sw, vertical: 18.sh),
                    child: Row(
                      mainAxisAlignment: isLogoutWidget
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          obj.value,
                          style: AppTextStyles.defaultTextStyle.copyWith(
                            fontSize: 16.fs,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textMediumColorOnForm,
                          ),
                        ),
                        isLogoutWidget
                            ? Padding(
                                padding: EdgeInsets.only(left: 10.sw),
                                child: SvgPicture.asset(
                                  AppAssets.logoutIconSvg,
                                  height: 18.sh,
                                  color: AppColors.appRed,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : SvgPicture.asset(
                                AppAssets.backIconSvg,
                                height: 12.sh,
                                color: AppColors.appMediumGrey,
                                fit: BoxFit.contain,
                              )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          loading ? const AppLoadingWidget() : const Offstage(),
        ],
      ),
    );
  }
}
