import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:helpampm/core/services/bloc/device_token_bloc.dart';
import 'package:helpampm/modules/config/ui/config_screen.dart';
import 'package:helpampm/utils/app_strings.dart';
import 'package:helpampm/utils/app_utils.dart';

import 'core/services/notification/notification_helper.dart';
import 'core/services/service_locator.dart';
import 'core/services/shared_preferences/shared_preference_helper.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// If you're going to use other Firebase services in the background, such as Firestore,
  /// make sure you call `initializeApp` before using other Firebase services.
  AppUtils.debugPrint('Handling a background message ${message.messageId}');

  NotificationHelper.navigateNotification(message: message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppUtils.debugPrint("Settting initliazation");
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  AppUtils.debugPrint("requestibg permsionss");
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    AppUtils.debugPrint('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    AppUtils.debugPrint('User granted provisional permission');
  } else {
    AppUtils.debugPrint('User declined or has not accepted permission');
  }

  AppUtils.debugPrint(messaging);

  AppUtils.debugPrint("message printed successfully");

  AppUtils.debugPrint("inside");
  String? aptoken;
  while (aptoken != null) {
    try {
      aptoken = await messaging.getAPNSToken();
      AppUtils.debugPrint(' token: $aptoken');
    } catch (e) {
      AppUtils.debugPrint("going for retry");
    }
  }
  String? token = await messaging.getToken();
  AppUtils.debugPrint(' token: $token');
  AppUtils.debugPrint(" firebase start ");
  await _initializeFirebaseMessaging();
  AppUtils.debugPrint(" firebase end ");
  // LocationManagerHandler.shared.resetLocationAndFetch();
  SharedPreferenceHelper().init();

  setupServiceLocator();

  /// Get device token and check if updated to server earlier
  await FirebaseMessaging.instance.getToken().then((value) {
    AppUtils.debugPrint("Firebase messaging device token generated: $value");
    if (value != null && value.isNotEmpty) {
      AppUtils.saveDeviceToken(value);
    } else {
      AppUtils.saveDeviceToken(AppStrings.emptyString);
    }
  });

  runApp(const ConfigScreen());
}

_initializeFirebaseMessaging() async {
  FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(alert: true);

  if (Platform.isAndroid) {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/launcher_icon");
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: (String? payload) async {
      //   if (payload != null) {
      //     AppUtils.debugPrint("Notification payload: $payload");
      //     NotificationHelper.navigateNotification(
      //         payload: payload, isNotificationClicked: true);
      //   }
      // },
    );

    final details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      AppUtils.debugPrint(
          "Notification details payload: ${details.notificationResponse}");
      NotificationHelper.navigateNotification(
          payload: details.notificationResponse);
    }
  }

  /// Register background push message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.instance.onTokenRefresh.listen((deviceToken) {
    AppUtils.debugPrint(
        "Firebase messaging refresh device token: $deviceToken");
    bool isLoggedIn = SharedPreferenceHelper().getIsUserLogin();
    AppUtils.saveDeviceToken(deviceToken.toString());
    AppUtils.setDeviceTokenUpdateStatus(false);
    if (isLoggedIn) {
      /// Call API to update token to server
      DeviceTokenBloc deviceTokenBloc = DeviceTokenBloc();
      deviceTokenBloc.stream.listen((event) {
        if (event == DeviceTokenState.loaded) {
          AppUtils.setDeviceTokenUpdateStatus(true);
        } else {
          AppUtils.setDeviceTokenUpdateStatus(false);
        }
      });
      AppUtils.debugPrint("-----Updating FCM Device Token------ main.dart");
      deviceTokenBloc.updateFCMDeviceToken(deviceToken.toString());
    }
  });

  /// TODO: uncomment as requirement
  configAndroidNotificationChannel(RemoteMessage message) async {
    AppUtils.debugPrint("----- Config Android Notification Channel -----");
    if (Platform.isAndroid) {
      const AndroidNotificationDetails androidNotificationDetailsSpecific =
          AndroidNotificationDetails(
        AppStrings.notificationChannelId,
        AppStrings.notificationChannelTitle,
        importance: Importance.high,
        priority: Priority.high,
        ticker: AppStrings.ticker,
      );

      const NotificationDetails platformChannelSpecific =
          NotificationDetails(android: androidNotificationDetailsSpecific);
      await flutterLocalNotificationsPlugin.show(
        Random().nextInt(500),
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecific,
        payload: message.data["status"],
      );
    }
  }

  /// Handle push notification in foreground state
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    AppUtils.debugPrint('Get a push message in the foreground ${message.data}');

    if (message.notification != null) {
      await configAndroidNotificationChannel(message);
    }
    NotificationHelper.navigateNotification(
        message: message, isNotificationClicked: true);
  });

  /// Replacement for onResume: When the app is in the background and open directly
  /// from the push notification.
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    AppUtils.debugPrint('Navigate push message on app resume: ${message.data}');
    NotificationHelper.navigateNotification(
        message: message, isNotificationClicked: true);
  });
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  AppStrings.notificationChannelId,
  AppStrings.notificationChannelTitle,
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
