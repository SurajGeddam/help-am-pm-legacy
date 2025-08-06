import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpampm/utils/app_constant.dart';

import '../../utils/app_strings.dart';
import '../../utils/app_utils.dart';
import '../common_models/marker_item_model.dart';

class GoogleMapWidget extends StatefulWidget {
  final LatLng latLng;
  final List<MarkerItemModel>? markerItemList;
  final bool isForSearchProvider;
  final double zoomValue;

  const GoogleMapWidget(
      {Key? key,
      required this.latLng,
      this.markerItemList,
      this.isForSearchProvider = false,
      this.zoomValue = 10.0})
      : super(key: key);

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  PolylinePoints polylinePoints = PolylinePoints();

  List<Marker> markersList = [];
  List<Polyline> polylineList = [];
  List<LatLng> polylineCoordinates = [];

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    addMarker(MarkerItemModel(
      id: AppStrings.markerId,
      title: AppStrings.currentLocation,
      snippet: AppStrings.thisIsYourCurrentLocation,
      location: widget.latLng,
    ));
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  addMarker(MarkerItemModel item) async {
    // var markerIcon = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(), item.imageString);
    Uint8List? markerIcon = await getBytesFromAsset(
        item.imageString, (item.id == AppStrings.markerId ? 80 : 160));

    Marker marker = Marker(
      markerId: MarkerId(item.id),
      position: item.location,
      infoWindow: InfoWindow(title: item.title, snippet: item.snippet),
      // icon: markerIcon,
      icon: BitmapDescriptor.fromBytes(markerIcon!),
    );

    Future.delayed(
        Duration.zero, () => setState(() => markersList.add(marker)));
  }

  addPolyLine() {
    PolylineId id = const PolylineId(AppStrings.polyId);
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 4,
    );

    Future.delayed(
        Duration.zero, () => setState(() => polylineList.add(polyline)));
  }

  getPolyline(MarkerItemModel item) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConstants.mapAPIKey,
      PointLatLng(widget.latLng.latitude, widget.latLng.longitude),
      PointLatLng(getDefaultDoubleValue(item.location.latitude),
          getDefaultDoubleValue(item.location.longitude)),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    addPolyLine();
  }

  init() {
    if (widget.markerItemList != null &&
        (widget.markerItemList?.isNotEmpty ?? false)) {
      List<MarkerItemModel>? itemList = widget.markerItemList;
      if (itemList != null) {
        for (var item in itemList) {
          addMarker(item);
        }
        if (!widget.isForSearchProvider) {
          getPolyline((widget.markerItemList?.first)!);
        }
      }
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    markersList.clear();
    polylineList.clear();
    polylineCoordinates.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      apiKey: AppConstants.mapAPIKey,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: widget.latLng,
        zoom: widget.zoomValue,
        //zoom: 18.0,
      ),
      markers: Set.from(markersList),
      polylines: Set.from(polylineList),
      scrollGesturesEnabled: true,
      myLocationButtonEnabled: false,
      rotateGesturesEnabled: false,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: true,
    );
  }
}
