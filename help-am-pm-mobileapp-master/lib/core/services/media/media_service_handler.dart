import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../permission/permission_service.dart';
import '../service_locator.dart';
import 'media_service.dart';

class MediaServiceHandler implements MediaService {
  @override
  PermissionService get permissionService => getIt<PermissionService>();

  /*Future<bool> _handleImageUploadPermissions(
      BuildContext context, AppImageSource? imageSource) async {
    if (imageSource == null) {
      return false;
    }
    if (imageSource == AppImageSource.camera) {
      return await permissionService.handleCameraPermission(context);
    } else if (imageSource == AppImageSource.gallery) {
      return await permissionService.handlePhotosPermission(context);
    } else {
      return false;
    }
  }*/

  @override
  Future<File?> uploadImage(
    BuildContext context,
    AppImageSource appImageSource, {
    bool shouldCompress = true,
  }) async {
    /// Handle permissions according to image source,
    // bool canProceed =
    //     await _handleImageUploadPermissions(context, appImageSource);

    // if (canProceed)
    {
      File? processedPickedImageFile;

      /// Convert our own AppImageSource into a format readable by the used package
      /// In this case it's an ImageSource enum
      ImageSource? imageSource = ImageSource.values.byName(appImageSource.name);

      final imagePicker = ImagePicker();
      final rawPickedImageFile =
          await imagePicker.pickImage(source: imageSource, imageQuality: 80);

      if (rawPickedImageFile != null) {
        /// to convert from XFile type provided by the package to dart:io's File type
        processedPickedImageFile = File(rawPickedImageFile.path);
        if (shouldCompress) {
          processedPickedImageFile =
              await compressFile(processedPickedImageFile);
        }
      }
      return processedPickedImageFile;
    }
    // return null;
  }

  @override
  Future<File?> compressFile(File file, {int quality = 40}) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath =
        '${dir.absolute.path}/${Random().nextInt(1000)}-temp.jpg';

    return await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
    );
  }
}
