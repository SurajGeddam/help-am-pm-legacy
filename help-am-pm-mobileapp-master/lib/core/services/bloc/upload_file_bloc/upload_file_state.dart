import 'dart:io';

import '../../../../utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../model/upload_file_response_model.dart';

abstract class UploadFileState {}

class UploadFileInitialState extends UploadFileState {}

class UploadFileLoadingState extends UploadFileState {}

class UploadFileCompleteState extends UploadFileState {
  final UploadFileResponseModel responseModel;
  final File imageFile;

  UploadFileCompleteState(
      {required this.responseModel, required this.imageFile});
}

class UploadFileErrorState extends UploadFileState {
  final String errorMessage;
  final Color bgColor;

  UploadFileErrorState(this.errorMessage, {this.bgColor = AppColors.black});
}
