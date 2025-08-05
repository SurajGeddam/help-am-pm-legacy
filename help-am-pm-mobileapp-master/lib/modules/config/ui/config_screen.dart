import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:helpampm/modules/splash/ui/splash_screen.dart';
import 'package:helpampm/utils/app_constant.dart';

import '../../../core/routes/routes.dart';
import '../../../core/services/bloc/loading_indicator_bloc.dart';
import '../../../core/services/bloc/location_cubit.dart';
import '../../../core/services/bloc/quotes_bloc/quotes_cubit.dart';
import '../../../core/services/bloc/upload_file_bloc/upload_file_cubit.dart';
import '../../../core_components/common_screens/undefined_screen.dart';
import '../../../core_components/i18n/language_codes.dart';
import '../../../core_components/i18n/localization.dart';
import '../../../core_components/i18n/localization_facade.dart';
import '../../../utils/app_utils.dart';
import '../../address/bloc/address_cubit/address_cubit.dart';
import '../../app_drawer/bloc/logout_cubit.dart';
import '../../app_drawer/bloc/user_dto_cubit.dart';
import '../../help/bloc/faq_cubit/faq_cubit.dart';
import '../../login/bloc/login_bloc/login_bloc.dart';
import '../../notifications/bloc/notification_cubit/notification_cubit.dart';
import '../../onboarding/bloc/insurance_bloc/insurance_bloc.dart';
import '../../onboarding/bloc/license_bloc/license_bloc.dart';
import '../../onboarding/bloc/vehicle_bloc/vehicle_bloc.dart';
import '../../ongoing_orders/bloc/ongoing_order_cubit/ongoing_order_cubit.dart';
import '../../profile/bloc/provider_profile_cubit/provider_profile_cubit.dart';
import '../../profile/bloc/save_profile_bloc/save_profile_bloc.dart';
import '../../provider_home/bloc/provider_log_cubit/provider_log_cubit.dart';
import '../../provider_new_order/bloc/new_order_cubit/new_order_cubit.dart';
import '../../provider_orders/bloc/add_remove_item_bloc/add_remove_item_bloc.dart';
import '../../provider_orders/bloc/schedule_order_cubit/schedule_order_cubit.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String defaultLanguage = AppUtils.getSelectedLanguage();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalizationFacade>(
          create: (BuildContext context) => LocalizationFacade(),
        ),
        BlocProvider<LocationCubit>(
          create: (BuildContext context) => LocationCubit(),
        ),
        BlocProvider<InsuranceBloc>(
          create: (BuildContext context) => InsuranceBloc(),
        ),
        BlocProvider<LicenseBloc>(
          create: (BuildContext context) => LicenseBloc(),
        ),
        BlocProvider<VehicleBloc>(
          create: (BuildContext context) => VehicleBloc(),
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(),
        ),
        BlocProvider<UploadFileCubit>(
          create: (BuildContext context) => UploadFileCubit(),
        ),
        BlocProvider<AddressCubit>(
          create: (BuildContext context) => AddressCubit(),
        ),
        BlocProvider<ProviderLogCubit>(
          create: (BuildContext context) => ProviderLogCubit(),
        ),
        BlocProvider<ScheduleOrderCubit>(
          create: (BuildContext context) => ScheduleOrderCubit(),
        ),
        BlocProvider<NewOrderCubit>(
          create: (BuildContext context) => NewOrderCubit(),
        ),
        BlocProvider<OngoingOrderCubit>(
          create: (BuildContext context) => OngoingOrderCubit(),
        ),
        BlocProvider<ProfileCubit>(
          create: (BuildContext context) => ProfileCubit(),
        ),
        BlocProvider<SaveProfileBloc>(
          create: (BuildContext context) => SaveProfileBloc(),
        ),
        BlocProvider<FaqCubit>(
          create: (BuildContext context) => FaqCubit(),
        ),
        BlocProvider<AddRemoveItemBloc>(
          create: (BuildContext context) => AddRemoveItemBloc(),
        ),
        BlocProvider<QuotesCubit>(
          create: (BuildContext context) => QuotesCubit(),
        ),
        BlocProvider<LogoutCubit>(
          create: (BuildContext context) => LogoutCubit(),
        ),
        BlocProvider<NotificationCubit>(
          create: (BuildContext context) => NotificationCubit(),
        ),
        BlocProvider<LoadingIndicatorBloc>(
          create: (BuildContext context) => LoadingIndicatorBloc(),
        ),
        BlocProvider<UserDtoCubit>(
          create: (BuildContext context) => UserDtoCubit(),
        ),
        BlocProvider<ProfileCubit>(
          create: (BuildContext context) => ProfileCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: GlobalKeys.navigatorKey,
        title: AppConstants.applicationName,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: AppConstants.fontFamily,
          brightness: Brightness.light,
          disabledColor: Colors.grey,
          appBarTheme: const AppBarTheme(elevation: 0.0),
        ),
        supportedLocales: [
          Locale(LanguageCodes.english.code, LanguageCodes.english.countryCode),
          Locale(LanguageCodes.spanish.code, LanguageCodes.spanish.countryCode),
        ],
        localizationsDelegates: [
          Localization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale.fromSubtags(languageCode: defaultLanguage),
        home: const SplashScreen(),
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => UndefinedScreen(name: settings.name),
        ),
      ),
    );
  }
}
