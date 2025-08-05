import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_styles.dart';
import 'custom_app_bar_widget.dart';

class AppScaffoldWidget extends StatelessWidget {
  final Color scaffoldBgColor;
  final Color appBarBgColor;
  final bool isAppBarShow;
  final bool isCenterTitle;
  final String appTitle;
  final TextStyle? appTitleTextStyle;
  final VoidCallback? onTapBack;
  final Widget? drawer;
  final Widget child;
  final bool isDividerShow;
  final bool isHomeScreen;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onRefreshPressed;
  final bool safeAreaTop;
  final bool isBackShow;
  final bool isLogoutShow;
  final VoidCallback? onLogoutPressed;

  const AppScaffoldWidget({
    Key? key,
    this.scaffoldBgColor = AppColors.white,
    this.appBarBgColor = AppColors.white,
    this.isAppBarShow = true,
    this.isCenterTitle = true,
    this.appTitle = AppStrings.emptyString,
    this.appTitleTextStyle,
    this.onTapBack,
    this.drawer,
    required this.child,
    this.isDividerShow = true,
    this.isHomeScreen = false,
    this.onSearchPressed,
    this.onRefreshPressed,
    this.safeAreaTop = true,
    this.isBackShow = true,
    this.isLogoutShow = false,
    this.onLogoutPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: scaffoldBgColor,
      appBar: isAppBarShow
          ? CustomAppBarWidget(
              isDividerShow: isDividerShow,
              backgroundColor: appBarBgColor,
              centerTitle: isCenterTitle,
              appTitle: appTitle,
              appTitleTextStyle: appTitleTextStyle ??
                  AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 16.fs,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
              onTap: onTapBack ?? () => Navigator.pop(context),
              isHomeScreen: isHomeScreen,
              onSearchPressed: onSearchPressed,
              onRefreshPressed: onRefreshPressed,
              isBackShow: isBackShow,
              isLogoutShow: isLogoutShow,
              onLogoutPressed: onLogoutPressed,
            )
          : null,
      drawer: drawer,
      body: SafeArea(
        top: safeAreaTop,
        bottom: false,
        child: child,
      ),
    );
  }
}
