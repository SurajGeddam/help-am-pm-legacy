class UploadFileModel {
  String fileName;
  String purpose;
  bool replace;

  UploadFileModel({
    required this.fileName,
    required this.purpose,
    this.replace = true,
  });
}
