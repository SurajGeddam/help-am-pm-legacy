class SearchProviderReqBodyModel {
  final String category;
  final bool isResidential;
  final bool isCommercial;
  final double latitude;
  final double longitude;
  final double altitude;
  final double radius;

  SearchProviderReqBodyModel({
    required this.category,
    required this.isResidential,
    required this.isCommercial,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.radius,
  });
}
