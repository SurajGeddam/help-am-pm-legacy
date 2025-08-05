// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_file_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadFileResponseModel _$UploadFileResponseModelFromJson(
        Map<String, dynamic> json) =>
    UploadFileResponseModel(
      message: json['message'] as String?,
      status: json['status'] as int?,
      uploadedPath: json['uploadedPath'] as String?,
      uploadImageBytes: json['uploadImageBytes'] as String?,
    );

Map<String, dynamic> _$UploadFileResponseModelToJson(
        UploadFileResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'uploadedPath': instance.uploadedPath,
      'uploadImageBytes': instance.uploadImageBytes,
    };
