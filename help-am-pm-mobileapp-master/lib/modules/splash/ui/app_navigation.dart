import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/login/ui/login_screen.dart';
import '../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../customer_home/ui/customer_home_screen.dart';
import '../../login/bloc/login_bloc/login_bloc.dart';
import '../../onboarding/ui/bank_information_screen.dart';
import '../../onboarding/ui/company_details_screen.dart';
import '../../onboarding/ui/how_to_earn_with_help_screen.dart';
import '../../onboarding/ui/insurance_information_screen.dart';
import '../../onboarding/ui/license_information_screen.dart';
import '../../onboarding/ui/trade_license_information_screen.dart';
import '../../onboarding/ui/vehicle_information_screen.dart';
import '../../provider_home/ui/provider_home_screen.dart';

class AppNavigation {
  static SharedPreferenceHelper preferenceHelper = SharedPreferenceHelper();

  static Future<void> getPath(BuildContext context,
      {isFromLogin = false}) async {
    String role =
        preferenceHelper.getStringValue(SharedPreferenceConstants.role);
    AppUtils.debugPrint("role => $role");

    switch (role) {
      case AppConstants.customer:
        await Future.delayed(Duration.zero, () async {
          Navigator.pushReplacementNamed(
              context, await userIsCustomer(context, isFromLogin));
        });
        break;

      case AppConstants.provider:
        await Future.delayed(Duration.zero, () async {
          Navigator.pushReplacementNamed(
              context, await userIsProvider(context, isFromLogin));
        });
        break;

      default:
        await Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        });
        break;
    }
  }

  static Future<String> userIsCustomer(
      BuildContext context, bool isFromLogin) async {
    String path = isFromLogin
        ? CustomerHomeScreen.routeName
        : await BlocProvider.of<LoginBloc>(context).refreshToken().then(
            (e) => e ? CustomerHomeScreen.routeName : LoginScreen.routeName);
    AppUtils.debugPrint("path => $path");
    return path;
  }

  static Future<String> userIsProvider(
      BuildContext context, bool isFromLogin) async {
    String path = LoginScreen.routeName;
    if (preferenceHelper
        .getBoolValue(SharedPreferenceConstants.accountSetupCompleted)) {
      path = ProviderHomeScreen.routeName;
    } else {
      path = isFromLogin
          ? getPathString()
          : await BlocProvider.of<LoginBloc>(context)
              .refreshToken()
              .then((bool e) => e ? getPathString() : LoginScreen.routeName);
    }
    AppUtils.debugPrint("path => $path");
    return path;
  }

  static String getPathString() {
    String value = preferenceHelper
        .getStringValue(SharedPreferenceConstants.completedPage);
    switch (value) {
      case AppConstants.category:
        return CompanyDetailsScreen.routeName;
      case AppConstants.individual:
        return InsuranceInformationScreen.routeName;
      case AppConstants.insurance:
        return LicenseInformationScreen.routeName;
      case AppConstants.businessLicense:
        return (preferenceHelper.getStringValue(
                    SharedPreferenceConstants.providerCategory) ==
                AppConstants.l)
            ? VehicleInformationScreen.routeName
            : TradeLicenseInformationScreen.routeName;
      case AppConstants.tradeLicense:
        return VehicleInformationScreen.routeName;
      case AppConstants.vehicle:
        return BankInformationScreen.routeName;
      case AppConstants.bank:
        return ProviderHomeScreen.routeName;
      default:
        return HowToEarnWithHelpScreen.routeName;
    }
  }
}
