import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_colors.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../utils/app_assets.dart';
import 'app_navigation.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  validateDeviceLocation() async {
    Future.delayed(
        const Duration(seconds: 2), () => AppNavigation.getPath(context));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => validateDeviceLocation());
  }

  @override
  Widget build(BuildContext context) {
    AppUtils.deviceHeight = MediaQuery.of(context).size.height;
    AppUtils.deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.appYellow,
      body: Container(
        height: AppUtils.deviceHeight,
        width: AppUtils.deviceWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.splashBg),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Image.asset(
            AppAssets.appLogo,
            height: 248.sh,
            width: 248.sw,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
