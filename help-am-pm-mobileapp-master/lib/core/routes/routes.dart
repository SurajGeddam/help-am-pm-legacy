import 'package:flutter/material.dart';
import 'package:helpampm/core_components/common_screens/undefined_screen.dart';
import 'package:helpampm/modules/login/ui/login_screen.dart';
import 'package:helpampm/modules/login/ui/register_screen.dart';
import 'package:helpampm/modules/splash/ui/splash_screen.dart';
import '../../core_components/common_models/key_value_model.dart';
import '../../modules/address/model/save_address_model/request_body/save_address_req_body_model.dart';
import '../../modules/address/ui/save_new_address_screen.dart';
import '../../modules/address/ui/address_screen.dart';
import '../../modules/app_drawer/ui/app_drawer_screen.dart';
import '../../modules/carousel/ui/carousel_screen.dart';
import '../../modules/contact_us/ui/contact_us_screen.dart';
import '../../modules/customer_booking/model/service_charge_model.dart';
import '../../modules/customer_booking/ui/booking_now_screen.dart';
import '../../modules/customer_booking/ui/booking_schedule_screen.dart';
import '../../modules/customer_booking/ui/booking_selection_screen.dart';
import '../../modules/customer_home/ui/customer_home_screen.dart';
import '../../modules/cutomer_location/ui/confirm_location_screen.dart';
import '../../modules/feedback/ui/feedback_screen.dart';
import '../../modules/google_search/google_search.dart';
import '../../modules/help/ui/faq_screen.dart';
import '../../modules/help/ui/help_screen.dart';
import '../../modules/invite/ui/invite_screen.dart';
import '../../modules/login/ui/change_password.dart';
import '../../modules/notifications/ui/notifications_screen.dart';
import '../../modules/onboarding/ui/bank_information_screen.dart';
import '../../modules/onboarding/ui/choose_category_screen.dart';
import '../../modules/login/ui/create_new_password_screen.dart';
import '../../modules/login/ui/enter_otp_screen.dart';
import '../../modules/login/ui/forgot_password_screen.dart';
import '../../modules/onboarding/ui/company_details_screen.dart';
import '../../modules/onboarding/ui/how_to_earn_with_help_screen.dart';
import '../../modules/onboarding/ui/insurance_information_screen.dart';
import '../../modules/onboarding/ui/license_information_screen.dart';
import '../../modules/onboarding/ui/pro_team_members_screen.dart';
import '../../modules/onboarding/ui/trade_license_information_screen.dart';
import '../../modules/onboarding/ui/vehicle_information_screen.dart';
import '../../modules/ongoing_orders/ui/ongoing_order_list_screen.dart';
import '../../modules/ongoing_service/ui/ongoing_service_screen.dart';
import '../../modules/options/ui/options_screen.dart';
import '../../modules/order_tracking/ui/order_tracking_screen.dart';
import '../../modules/payment/ui/add_payment_screen.dart';
import '../../modules/payment/ui/card_list_screen.dart';
import '../../modules/profile/ui/profile_screen.dart';
import '../../modules/provider_home/ui/provider_home_screen.dart';
import '../../modules/provider_new_order/model/api/new_order_list_model.dart';
import '../../modules/provider_new_order/ui/provider_new_order_list_screen.dart';
import '../../modules/provider_new_order/ui/provider_new_order_screen.dart';
import '../../modules/provider_orders/ui/order_details_screen.dart';
import '../../modules/provider_orders/ui/order_history_tab_widget.dart';
import '../../modules/provider_orders/ui/order_information_screen.dart';
import '../../modules/provider_orders/ui/order_schedule_tab_widget.dart';
import '../../modules/provider_orders/ui/provider_orders_screen.dart';
import '../../modules/searching_provider/model/search_provider_req_body_model.dart';
import '../../modules/searching_provider/ui/searching_provider_screen.dart';
import '../../modules/service_provider/ui/service_provider_screen.dart';
import '../../modules/setting/setting_screen.dart';
import '../../modules/started_booking/ui/started_booking_detail_screen.dart';
import '../../modules/summary/ui/customer_summary_screen.dart';
import '../../modules/summary/ui/thanks_feedback_screen.dart';
import 'fade_route.dart';

const String splashScreen = SplashScreen.routeName;
const String optionsScreen = OptionsScreen.routeName;
const String loginScreen = LoginScreen.routeName;
const String registerScreen = RegisterScreen.routeName;
const String forgotPasswordScreen = ForgotPasswordScreen.routeName;
const String enterOTPScreen = EnterOTPScreen.routeName;
const String createNewPasswordScreen = CreateNewPasswordScreen.routeName;
const String chooseCategoryScreen = ChooseCategoryScreen.routeName;
const String howToEarnWithHelpScreen = HowToEarnWithHelpScreen.routeName;
const String companyDetailsScreen = CompanyDetailsScreen.routeName;
const String insuranceInformationScreen = InsuranceInformationScreen.routeName;
const String licenseInformationScreen = LicenseInformationScreen.routeName;
const String tradeLicenseInformationScreen =
    TradeLicenseInformationScreen.routeName;
const String vehicleInformationScreen = VehicleInformationScreen.routeName;
const String bankInformationScreen = BankInformationScreen.routeName;
const String proTeamMembersScreen = ProTeamMembersScreen.routeName;
const String providerHomeScreen = ProviderHomeScreen.routeName;
const String providerOrdersListScreen = ProviderOrdersListScreen.routeName;
const String orderInformationScreen = OrderInformationScreen.routeName;
const String orderDetailsScreen = OrderDetailsScreen.routeName;
const String contactUsScreen = ContactUsScreen.routeName;
const String changePasswordScreen = ChangePasswordScreen.routeName;
const String helpScreen = HelpScreen.routeName;
const String faqScreen = FaqScreen.routeName;
const String notificationsScreen = NotificationsScreen.routeName;
const String profileScreen = ProfileScreen.routeName;
const String startedBookingDetailScreen = StartedBookingDetailScreen.routeName;
const String feedbackScreen = FeedbackScreen.routeName;
const String providerNewOrderScreen = ProviderNewOrderScreen.routeName;
const String appDrawerScreen = AppDrawerScreen.routeName;
const String orderHistoryTabWidget = OrderHistoryTabWidget.routeName;
const String orderScheduleTabWidget = OrderScheduleTabWidget.routeName;
const String customerHomeScreen = CustomerHomeScreen.routeName;
const String carouselScreen = CarouselScreen.routeName;
const String inviteScreen = InviteScreen.routeName;
const String bookingSelectionScreen = BookingSelectionScreen.routeName;
const String bookingNowScreen = BookingNowScreen.routeName;
const String bookingScheduleScreen = BookingScheduleScreen.routeName;
const String addressScreen = AddressScreen.routeName;
const String ongoingServiceScreen = OngoingServiceScreen.routeName;
const String addPaymentScreen = AddPaymentScreen.routeName;
const String serviceProviderScreen = ServiceProviderScreen.routeName;
const String saveNewAddressScreen = SaveNewAddressScreen.routeName;
const String customerSummary = CustomerSummaryScreen.routeName;
const String thanksFeedbackScreen = ThanksFeedbackScreen.routeName;
const String cardListScreen = CardListScreen.routeName;
const String confirmLocationScreen = ConfirmLocationScreen.routeName;
const String searchingProviderScreen = SearchingProviderScreen.routeName;
const String orderTrackingScreen = OrderTrackingScreen.routeName;
const String providerNewOrderListScreen = ProviderNewOrderListScreen.routeName;
const String ongoingOrderListScreen = OngoingOrderListScreen.routeName;
const String googleSearchScreen = GoogleSearchScreen.routeName;
const String settingScreen = SettingScreen.routeName;

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashScreen:
      return MaterialPageRoute(builder: (_) => const SplashScreen());

    case optionsScreen:
      return MaterialPageRoute(builder: (_) => const OptionsScreen());

    case loginScreen:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    case registerScreen:
      // return FadeRoute(
      //     page:
      //         RegisterScreen(keyValueObj: settings.arguments as KeyValueModel));

      return MaterialPageRoute(
          builder: (_) =>
              RegisterScreen(keyValue: settings.arguments as String));

    case forgotPasswordScreen:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

    case enterOTPScreen:
      Map<String, dynamic> arguments =
          settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (_) => EnterOTPScreen(
                userId: arguments["userId"],
                systemOtp: arguments["systemOtp"],
              ));

    case createNewPasswordScreen:
      Map<String, dynamic> arguments =
          settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (_) => CreateNewPasswordScreen(
                userId: arguments["userId"],
                otp: arguments["otp"],
              ));

    case chooseCategoryScreen:
      Map<String, dynamic>? arguments = settings.arguments != null
          ? settings.arguments as Map<String, dynamic>
          : null;
      SaveAddressReqBodyModel? address;
      KeyValueModel? categoryObj;

      if (arguments != null) {
        address = (arguments["address"] != null)
            ? arguments["address"] as SaveAddressReqBodyModel
            : null;
        categoryObj = (arguments["categoryObj"] != null)
            ? arguments["categoryObj"] as KeyValueModel
            : null;
      }

      return MaterialPageRoute(
          builder: (_) => ChooseCategoryScreen(
                addressModel: address,
                categoryObj: categoryObj,
              ));

    case howToEarnWithHelpScreen:
      return MaterialPageRoute(builder: (_) => const HowToEarnWithHelpScreen());

    case companyDetailsScreen:
      return MaterialPageRoute(builder: (_) => const CompanyDetailsScreen());

    case insuranceInformationScreen:
      return MaterialPageRoute(
          builder: (_) => const InsuranceInformationScreen());

    case licenseInformationScreen:
      return MaterialPageRoute(
          builder: (_) => const LicenseInformationScreen());

    case tradeLicenseInformationScreen:
      return MaterialPageRoute(
          builder: (_) => const TradeLicenseInformationScreen());

    case vehicleInformationScreen:
      return MaterialPageRoute(
          builder: (_) => const VehicleInformationScreen());

    case bankInformationScreen:
      return MaterialPageRoute(builder: (_) => const BankInformationScreen());

    case proTeamMembersScreen:
      return MaterialPageRoute(builder: (_) => const ProTeamMembersScreen());

    case providerHomeScreen:
      return MaterialPageRoute(builder: (_) => const ProviderHomeScreen());

    case providerOrdersListScreen:
      return MaterialPageRoute(
          builder: (_) => const ProviderOrdersListScreen());

    case orderDetailsScreen:
      Quotes arguments = settings.arguments as Quotes;
      return MaterialPageRoute(
        builder: (_) => OrderDetailsScreen(
          scheduleOrder: arguments,
        ),
      );

    case orderInformationScreen:
      Quotes scheduleOrder = settings.arguments as Quotes;
      return MaterialPageRoute(
        builder: (_) => OrderInformationScreen(scheduleOrder: scheduleOrder),
      );

    case helpScreen:
      return MaterialPageRoute(builder: (_) => const HelpScreen());

    case faqScreen:
      return MaterialPageRoute(builder: (_) => const FaqScreen());

    case contactUsScreen:
      return MaterialPageRoute(builder: (_) => const ContactUsScreen());

    case changePasswordScreen:
      return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());

    case notificationsScreen:
      return MaterialPageRoute(builder: (_) => const NotificationsScreen());

    case profileScreen:
      return MaterialPageRoute(builder: (_) => const ProfileScreen());

    case startedBookingDetailScreen:
      Quotes quotes = settings.arguments as Quotes;
      return MaterialPageRoute(
          builder: (_) => StartedBookingDetailScreen(
                scheduleOrder: quotes,
              ));

    case feedbackScreen:
      Quotes quotes = settings.arguments as Quotes;
      return MaterialPageRoute(
          builder: (_) => FeedbackScreen(scheduleOrder: quotes));

    case providerNewOrderScreen:
      Quotes quotes = settings.arguments as Quotes;
      return MaterialPageRoute(
          builder: (_) => ProviderNewOrderScreen(scheduleOrder: quotes));

    case appDrawerScreen:
      return FadeRoute(page: const AppDrawerScreen());

    case orderHistoryTabWidget:
      Map<String, dynamic> arguments =
          settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (_) => OrderHistoryTabWidget(
                isFromDrawer: arguments["isFromDrawer"],
              ));

    case orderScheduleTabWidget:
      Map<String, dynamic> arguments =
          settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (_) => OrderScheduleTabWidget(
                isFromDrawer: arguments["isFromDrawer"],
              ));

    case customerHomeScreen:
      return MaterialPageRoute(builder: (_) => const CustomerHomeScreen());

    case carouselScreen:
      return MaterialPageRoute(
          builder: (_) =>
              CarouselScreen(keyValue: settings.arguments as String));

    case bookingSelectionScreen:
      ServiceChargeModel obj = settings.arguments as ServiceChargeModel;
      return MaterialPageRoute(
          builder: (_) => BookingSelectionScreen(serviceChargeModel: obj));

    case bookingScheduleScreen:
      ServiceChargeModel serviceChargeModel =
          settings.arguments as ServiceChargeModel;
      return MaterialPageRoute(
          builder: (_) =>
              BookingScheduleScreen(serviceChargeModel: serviceChargeModel));

    case bookingNowScreen:
      ServiceChargeModel serviceChargeModel =
          settings.arguments as ServiceChargeModel;
      return MaterialPageRoute(
          builder: (_) =>
              BookingNowScreen(serviceChargeModel: serviceChargeModel));

    case addressScreen:
      bool value =
          (settings.arguments == null) ? false : settings.arguments as bool;
      return MaterialPageRoute(
          builder: (_) => AddressScreen(isFromChangeLocation: value));

    case ongoingServiceScreen:
      Map<String, dynamic> arguments =
          settings.arguments as Map<String, dynamic>;
      bool isProviderReached = (arguments["isProviderReached"] != null)
          ? arguments["isProviderReached"] as bool
          : false;
      Quotes? quotes =
          (arguments["quotes"] != null) ? arguments["quotes"] as Quotes : null;
      return MaterialPageRoute(
          builder: (_) => OngoingServiceScreen(
                isProviderReached: isProviderReached,
                quotes: quotes,
              ));

    case addPaymentScreen:
      return MaterialPageRoute(builder: (_) => const AddPaymentScreen());

    case serviceProviderScreen:
      Quotes quotes = settings.arguments as Quotes;
      return MaterialPageRoute(
          builder: (_) => ServiceProviderScreen(scheduleOrder: quotes));

    case saveNewAddressScreen:
      Map<String, dynamic>? arguments = settings.arguments != null
          ? settings.arguments as Map<String, dynamic>
          : null;
      SaveAddressReqBodyModel? address;
      KeyValueModel? categoryObj;
      bool isSavedAddress = false;
      bool isForUpdateAddress = false;

      if (arguments != null) {
        address = (arguments["address"] != null)
            ? arguments["address"] as SaveAddressReqBodyModel
            : null;
        categoryObj = (arguments["categoryObj"] != null)
            ? arguments["categoryObj"] as KeyValueModel
            : null;
        isSavedAddress = (arguments["isSavedAddress"] ?? false);
        isForUpdateAddress = (arguments["isForUpdateAddress"] ?? false);
      }

      return MaterialPageRoute(
          builder: (_) => SaveNewAddressScreen(
                addressModel: address,
                categoryObj: categoryObj,
                isSavedAddress: isSavedAddress,
                isForUpdateAddress: isForUpdateAddress,
              ));

    case customerSummary:
      Quotes quotes = settings.arguments as Quotes;
      return MaterialPageRoute(
          builder: (_) => CustomerSummaryScreen(quotes: quotes));

    case thanksFeedbackScreen:
      return MaterialPageRoute(builder: (_) => const ThanksFeedbackScreen());

    case cardListScreen:
      return MaterialPageRoute(builder: (_) => const CardListScreen());

    case confirmLocationScreen:
      KeyValueModel? obj = (settings.arguments != null
          ? settings.arguments as KeyValueModel
          : null);
      return MaterialPageRoute(
          builder: (_) => ConfirmLocationScreen(categoryObj: obj));

    case searchingProviderScreen:
      SearchProviderReqBodyModel obj =
          settings.arguments as SearchProviderReqBodyModel;
      return MaterialPageRoute(
          builder: (_) => SearchingProviderScreen(searchProviderReqBody: obj));

    case orderTrackingScreen:
      Quotes quotes = settings.arguments as Quotes;
      return MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(quotes: quotes));

    case providerNewOrderListScreen:
      return MaterialPageRoute(
          builder: (_) => const ProviderNewOrderListScreen());

    case ongoingOrderListScreen:
      return MaterialPageRoute(builder: (_) => const OngoingOrderListScreen());

    case googleSearchScreen:
      return MaterialPageRoute(builder: (_) => const GoogleSearchScreen());

    case settingScreen:
      return MaterialPageRoute(builder: (_) => const SettingScreen());

    default:
      return MaterialPageRoute(builder: (_) => const UndefinedScreen());
  }
}
