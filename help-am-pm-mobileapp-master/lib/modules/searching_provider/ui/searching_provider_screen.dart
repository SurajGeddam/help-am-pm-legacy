import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpampm/modules/searching_provider/ui/widgets/component_widget_with_ok.dart';
import '../../../core_components/common_models/marker_item_model.dart';
import '../../../core_components/common_widgets/app_error_message_widget.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/google_map_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_utils.dart';
import '../bloc/search_provider_cubit/search_provider_cubit.dart';
import '../bloc/search_provider_cubit/search_provider_state.dart';
import '../model/search_provider_req_body_model.dart';
import '../model/search_provider_response_model.dart';
import 'widgets/component_widget.dart';

class SearchingProviderScreen extends StatefulWidget {
  static const String routeName = "/SearchingProviderScreen";
  final SearchProviderReqBodyModel searchProviderReqBody;

  const SearchingProviderScreen({
    Key? key,
    required this.searchProviderReqBody,
  }) : super(key: key);

  @override
  State<SearchingProviderScreen> createState() =>
      _SearchingProviderScreenState();
}

class _SearchingProviderScreenState extends State<SearchingProviderScreen> {
  late SearchProviderCubit searchProviderCubit;
  late LatLng latLng;
  bool isTimeOver = false;

  void init() async {
    searchProviderCubit = SearchProviderCubit();
    searchProviderCubit.fetchSearchProvider(obj: widget.searchProviderReqBody);

    latLng = LatLng(widget.searchProviderReqBody.latitude,
        widget.searchProviderReqBody.longitude);
  }

  timeIsOvered() {
    setState(() => isTimeOver = true);
  }

  @override
  void initState() {
    init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 20), timeIsOvered);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.searching,
      isBackShow: false,
      child: BlocBuilder<SearchProviderCubit, SearchProviderState>(
        bloc: searchProviderCubit,
        builder: (ctx, state) {
          if (state is SearchProviderErrorState) {
            return AppErrorMessageWidget(
              errorMessage: state.errorMessage,
              textColor: state.bgColor,
            );
          } else if (state is SearchProviderLoadedState) {
            List<SearchProviderModel> list = state.list;
            List<MarkerItemModel> markerItemList = [];
            if (list.isNotEmpty) {
              for (var item in list) {
                markerItemList.add(MarkerItemModel(
                  id: getDefaultStringValue(item.name),
                  title: getDefaultStringValue(item.name),
                  imageString: AppUtils.getLocationIconOnMap(
                      widget.searchProviderReqBody.category.split("")[0]),
                  location: LatLng(getDefaultDoubleValue(item.latitude),
                      getDefaultDoubleValue(item.longitude)),
                ));
              }
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    width: AppUtils.deviceWidth,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        stops: [0.0, 1.0],
                        begin: FractionalOffset.bottomCenter,
                        end: FractionalOffset.topCenter,
                        tileMode: TileMode.repeated,
                        colors: [
                          Color(0xFFFCCD37),
                          Color(0xFFFAD047),
                        ],
                      ),
                    ),
                    alignment: Alignment.topCenter,
                    child: GoogleMapWidget(
                      isForSearchProvider: true,
                      latLng: latLng,
                      markerItemList: markerItemList,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: AppUtils.deviceWidth,
                    color: AppColors.white,
                    alignment: Alignment.center,
                    child: isTimeOver
                        ? const ComponentWidgetWithOkButton()
                        : const ComponentWidget(),
                  ),
                ),
              ],
            );
          }
          return const AppLoadingWidget();
        },
      ),
    );
  }
}
