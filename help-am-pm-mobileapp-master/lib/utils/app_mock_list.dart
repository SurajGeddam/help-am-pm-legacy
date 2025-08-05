import 'package:flutter/material.dart';
import 'package:helpampm/core/services/shared_preferences/shared_preference_helper.dart';
import 'package:helpampm/modules/notifications/ui/notifications_screen.dart';
import 'package:helpampm/utils/app_constant.dart';

import '../core/services/shared_preferences/shared_preference_constants.dart';
import '../core_components/common_models/card_model.dart';
import '../core_components/common_models/key_value_model.dart';
import '../core_components/common_models/user_profile_model.dart';
import '../modules/address/model/save_address_model/request_body/save_address_req_body_model.dart';
import '../modules/profile/ui/profile_screen.dart';
import '../modules/provider_orders/ui/provider_orders_screen.dart';
import 'app_assets.dart';
import 'app_colors.dart';
import 'app_strings.dart';

class AppMockList {
  AppMockList._();

  static List<CardModel> cardList = [
    CardModel(
      key: "0",
      cardNumber: "5469215425648754",
      ddyy: "05/26",
      cardHolderName: "CARD HOLDER NAME",
      cardType: "VISA",
    )
  ];

  static List<KeyValueModel> delayTimeList = [
    KeyValueModel(
      key: "0",
      value: "5",
      displayString: "5 minutes",
    ),
    KeyValueModel(
      key: "1",
      value: "10",
      displayString: "10 minutes",
    ),
    KeyValueModel(
      key: "2",
      value: "20",
      displayString: "20 minutes",
    ),
    KeyValueModel(
      key: "3",
      value: "30",
      displayString: "30 minutes",
    ),
    KeyValueModel(
      key: "4",
      value: "40",
      displayString: "40 minutes",
    ),
    KeyValueModel(
      key: "5",
      value: "50",
      displayString: "50 minutes",
    ),
    KeyValueModel(
      key: "6",
      value: "60",
      displayString: "60 minutes",
    ),
  ];

  static List<KeyValueModel> feedbackNoteList = [
    KeyValueModel(
      key: "0",
      value: AppStrings.firstClass,
    ),
    KeyValueModel(
      key: "1",
      value: AppStrings.wellDone,
    ),
    KeyValueModel(
      key: "2",
      value: AppStrings.niceWork,
    ),
    KeyValueModel(
      key: "3",
      value: AppStrings.impressiveWork,
    ),
    KeyValueModel(
      key: "4",
      value: AppStrings.greatJob,
    ),
  ];

  static List<KeyValueModel> paymentMethod = [
    KeyValueModel(
      key: AppConstants.crDrCard,
      value: AppStrings.creditDebitCard,
      isSelected: true,
    ),
    KeyValueModel(
      key: AppConstants.paypal,
      value: AppStrings.paypal,
    ),
  ];

  static List<KeyValueModel> typeOfAddress = [
    KeyValueModel(
      key: AppConstants.home,
      value: AppStrings.home,
      isSelected: true,
    ),
    KeyValueModel(
      key: AppConstants.work,
      value: AppStrings.work,
    ),
    KeyValueModel(
      key: AppConstants.other,
      value: AppStrings.other,
    ),
  ];

  static List<SaveAddressReqBodyModel> addressList = [
    SaveAddressReqBodyModel(
      id: 1,
      name: "Morris Falue",
      building: "1200 E",
      street: "California Blvd",
      district: "Pasadena",
      county: "CA",
      zipcode: "91125",
      addressType: "HOME",
      country: "United States",
      isDefault: true,
    ),
    SaveAddressReqBodyModel(
      id: 2,
      name: "Morris Falue",
      building: "1200 E",
      street: "California Blvd",
      district: "Pasadena",
      county: "CA",
      zipcode: "91125",
      addressType: "HOME",
      country: "United States",
      isDefault: false,
    ),
  ];

  static List<KeyValueModel> logoList = [
    KeyValueModel(
      key: AppStrings.hvac,
      value: AppStrings.hvacMsg,
      imageString: AppAssets.hvacImageSvg,
      bgColor: AppColors.hvacBgColor,
    ),
    KeyValueModel(
      key: AppStrings.electrical,
      value: AppStrings.hvacMsg,
      imageString: AppAssets.electricalImageSvg,
      bgColor: AppColors.electricalBgColor,
    ),
    KeyValueModel(
      key: AppStrings.locksmith,
      value: AppStrings.hvacMsg,
      imageString: AppAssets.locksmithImageSvg,
      bgColor: AppColors.locksmithBgColor,
    ),
    KeyValueModel(
      key: AppStrings.plumbing,
      value: AppStrings.hvacMsg,
      imageString: AppAssets.plumbingImageSvg,
      bgColor: AppColors.plumbingBgColor,
    ),
  ];

  static List<KeyValueModel> optionScreenList = [
    KeyValueModel(
      key: AppConstants.customer,
      value: AppStrings.customer,
      imageString: AppAssets.userLogoSvgIcon,
    ),
    KeyValueModel(
      key: AppConstants.provider,
      value: AppStrings.serviceProviderInTwoLine,
      imageString: AppAssets.providerLogoSvgIcon,
    ),
  ];

  static const List<String> categoryList = [
    "HVAC",
    "ELECTRICAL",
    "LOCKSMITH",
    "PLUMBER"
  ];

  static UserProfileModel userProfile = UserProfileModel(
    userId: "1212",
    firstName: "Matthew",
    lastName: "John",
    emailAddress: "matthew587@gmail.com",
    dob: "01-05-1992",
    mobileNumber: "+1 1469627820",
    password: "242342",
  );

  static List<KeyValueModel> customerDrawerItemsList = [
    KeyValueModel(
      key: AppConstants.history,
      value: AppStrings.orderHistory,
    ),
    KeyValueModel(
      key: AppConstants.schedule,
      value: AppStrings.scheduleOrders,
    ),
    KeyValueModel(
      key: AppConstants.savedAddress,
      value: AppStrings.savedAddress,
    ),
    KeyValueModel(
      key: AppConstants.notifications,
      value: AppStrings.notifications,
    ),
    KeyValueModel(
      key: AppConstants.settings,
      value: AppStrings.settings,
    ),
    KeyValueModel(
      key: AppConstants.helpNSupport,
      value: AppStrings.helpNSupport,
    ),
    /*KeyValueModel(
      key: AppConstants.contactUs,
      value: AppStrings.contactUs,
    ),*/
    KeyValueModel(
      key: AppConstants.changePassword,
      value: AppStrings.changePassword,
    ),
    KeyValueModel(
      key: AppConstants.logOut,
      value: AppStrings.logOut,
    ),
  ];

  static List<KeyValueModel> providerDrawerItemsList = [
    KeyValueModel(
      key: AppConstants.newOrder,
      value: AppStrings.newOrder,
    ),
    KeyValueModel(
      key: AppConstants.history,
      value: AppStrings.orderHistory,
    ),
    KeyValueModel(
      key: AppConstants.schedule,
      value: AppStrings.scheduleOrders,
    ),
    KeyValueModel(
      key: AppConstants.notifications,
      value: AppStrings.notifications,
    ),
    KeyValueModel(
      key: AppConstants.settings,
      value: AppStrings.settings,
    ),
    KeyValueModel(
      key: AppConstants.helpNSupport,
      value: AppStrings.helpNSupport,
    ),
    KeyValueModel(
      key: AppConstants.changePassword,
      value: AppStrings.changePassword,
    ),
    /*KeyValueModel(
      key: AppConstants.contactUs,
      value: AppStrings.contactUs,
    ),*/
    KeyValueModel(
      key: AppConstants.logOut,
      value: AppStrings.logOut,
    ),
  ];

  static List<KeyValueModel> settingItemList = [
    KeyValueModel(
      key: AppConstants.notifications,
      value: AppStrings.notifications,
    ),
    KeyValueModel(
      key: AppConstants.sms,
      value: AppStrings.sms,
    ),
    KeyValueModel(
      key: AppConstants.email,
      value: AppStrings.email,
    ),
  ];

  static const List<Tab> ordersTabs = <Tab>[
    Tab(text: AppStrings.history),
    Tab(text: AppStrings.schedule),
  ];

  static List<KeyValueModel> customerOperationsList = [
    KeyValueModel(
      key: AppConstants.hvac,
      value: AppConstants.h,
      displayString: AppStrings.hvac.toUpperCase(),
    ),
    KeyValueModel(
      key: AppConstants.electrical,
      value: AppConstants.e,
      displayString: AppStrings.electrical.toUpperCase(),
    ),
    KeyValueModel(
      key: AppConstants.locksmith,
      value: AppConstants.l,
      displayString: AppStrings.locksmith.toUpperCase(),
    ),
    KeyValueModel(
      key: AppConstants.plumbing,
      value: AppConstants.p,
      displayString: AppStrings.plumbing.toUpperCase(),
    ),
  ];

  static List<KeyValueModel> providerOperationsList = [
    KeyValueModel(
      key: AppAssets.orderHistoryIconSvg,
      value: AppStrings.orderHistory,
      routeName: ProviderOrdersListScreen.routeName,
    ),
    KeyValueModel(
      key: AppAssets.userLogoSvgIcon,
      value: AppStrings.manageProfile,
      routeName: ProfileScreen.routeName,
    ),
    KeyValueModel(
      key: AppAssets.notificationBellIconSvg,
      value: AppStrings.notifications,
      routeName: NotificationsScreen.routeName,
    ),
  ];

  static List<KeyValueModel> userInputDetailList = [
    KeyValueModel(
      key: AppConstants.individual,
      value: "1",
      displayString: AppStrings.individual,
    ),
    KeyValueModel(
      key: AppConstants.insurance,
      value: "2",
      displayString: AppStrings.insurance,
    ),
    KeyValueModel(
      key: AppConstants.businessLicense,
      value: "3",
      displayString: AppStrings.businessLicense,
    ),
    if (SharedPreferenceHelper()
            .getStringValue(SharedPreferenceConstants.providerCategory) !=
        AppConstants.l)
      KeyValueModel(
        key: AppConstants.tradeLicense,
        value: "4",
        displayString: AppStrings.tradeLicense,
      ),
    KeyValueModel(
      key: AppConstants.vehicle,
      value: "5",
      displayString: AppStrings.vehicle,
    ),
    KeyValueModel(
      key: AppConstants.bank,
      value: "6",
      displayString: AppStrings.bank,
    ),
  ];

  static List<KeyValueModel> earnWithHelpList = [
    KeyValueModel(
      key: "Sign Up",
      value: "Provide your basic details to start your account",
    ),
    KeyValueModel(
      key: "Get your account approved",
      value:
          "Get account verified by our team of experts and help you in verification",
    ),
    KeyValueModel(
      key: "Get Lead, Earn Commission",
      value: "Start getting new leads on your homepage , and earn commission",
    ),
    KeyValueModel(
      key: "Start Earning",
      value: "Earnings Starts from day 1",
    ),
  ];
}
