import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/utils/app_assets.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../utils/app_colors.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final Color backgroundColor;
  final bool centerTitle;
  final String appTitle;
  final TextStyle appTitleTextStyle;
  final VoidCallback onTap;
  final bool isDividerShow;
  final bool isHomeScreen;
  final bool isBackShow;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onRefreshPressed;
  final bool isLogoutShow;
  final VoidCallback? onLogoutPressed;

  const CustomAppBarWidget({
    Key? key,
    this.backgroundColor = AppColors.white,
    this.centerTitle = true,
    required this.appTitle,
    required this.appTitleTextStyle,
    required this.onTap,
    required this.isDividerShow,
    required this.isHomeScreen,
    required this.isBackShow,
    this.onSearchPressed,
    this.onRefreshPressed,
    required this.isLogoutShow,
    this.onLogoutPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56.sh);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                isBackShow
                    ? GestureDetector(
                        onTap: onTap,
                        child: AbsorbPointer(
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(18.sh),
                            child: RotatedBox(
                              quarterTurns: isHomeScreen ? 0 : 2,
                              child: SvgPicture.asset(
                                isHomeScreen
                                    ? AppAssets.humberIconSvg
                                    : AppAssets.backIconSvg,
                                height: 18.sh,
                                width: 18.sh,
                                fit: BoxFit.contain,
                                color: AppColors.textMediumColorOnForm,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(width: 36.sw),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 16.sh),
                    child: Text(
                      appTitle,
                      style: appTitleTextStyle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                isHomeScreen
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: onRefreshPressed,
                            child: AbsorbPointer(
                              child: Container(
                                padding: EdgeInsets.all(18.sh),
                                child: Icon(
                                  Icons.refresh,
                                  color: AppColors.appOrange,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: onSearchPressed,
                            child: AbsorbPointer(
                              child: Container(
                                padding: EdgeInsets.all(18.sh),
                                child: SvgPicture.asset(
                                  AppAssets.notificationBellOutlineIconSvg,
                                  height: 20.sh,
                                  fit: BoxFit.contain,
                                  color: AppColors.textMediumColorOnForm,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : SizedBox(width: 36.sw),
                (isLogoutShow && !isHomeScreen)
                    ? GestureDetector(
                        onTap: onLogoutPressed,
                        child: AbsorbPointer(
                          child: Container(
                            padding: EdgeInsets.all(18.sh),
                            child: SvgPicture.asset(
                              AppAssets.logoutIconSvg,
                              height: 18.sh,
                              color: AppColors.appRed,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(width: 36.sw),
              ],
            ),
            if (isDividerShow)
              Divider(
                height: 1.sh,
                thickness: 2.sh,
                color: AppColors.appDarkOrange,
              ),
          ],
        ),
      ),
    );
  }
}
