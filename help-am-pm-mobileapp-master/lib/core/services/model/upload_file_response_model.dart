import 'package:json_annotation/json_annotation.dart';

part 'upload_file_response_model.g.dart';

@JsonSerializable()
class UploadFileResponseModel {
  String? message;
  int? status;
  String? uploadedPath;
  String? uploadImageBytes;

  UploadFileResponseModel(
      {this.message, this.status, this.uploadedPath, this.uploadImageBytes});

  factory UploadFileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UploadFileResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$UploadFileResponseModelToJson(this);
}
