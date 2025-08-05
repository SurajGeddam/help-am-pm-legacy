import 'dart:io';
import 'package:helpampm/core/services/permission/permission_service.dart';
import 'package:helpampm/core_components/common_widgets/app_alert_dialog.dart';
import 'package:helpampm/utils/app_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionServiceHandler implements PermissionService {
  @override
  Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  @override
  Future<PermissionStatus> requestPhotosPermission() async {
    return Platform.isAndroid
        ? await Permission.storage.request()
        : await Permission.photos.request();
  }

  @override
  Future<bool> handleCameraPermission(BuildContext context) async {
    PermissionStatus cameraPermissionStatus = await requestCameraPermission();

    if (cameraPermissionStatus != PermissionStatus.granted) {
      AppUtils.debugPrint('---- Permission to camera was not granted! ----');
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AppAlertDialog(
            onConfirm: () => openAppSettings(),
            title: 'Camera Permission',
            subtitle:
                'Camera permission should Be granted to use this feature, would you like to go to app settings to give camera permission?',
          ),
        );
      }
      return false;
    }
    return true;
  }

  @override
  Future<bool> handlePhotosPermission(BuildContext context) async {
    PermissionStatus photosPermissionStatus = await requestPhotosPermission();

    if (photosPermissionStatus != PermissionStatus.granted) {
      AppUtils.debugPrint("--- Permission to photos not granted! ----");
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AppAlertDialog(
            onConfirm: () => openAppSettings(),
            title: 'Photos Permission',
            subtitle:
                'Photos permission should Be granted to use this feature, would you like to go to app settings to give photos permission?',
          ),
        );
      }
      return false;
    }
    return true;
  }
}
