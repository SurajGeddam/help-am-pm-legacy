import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../../core_components/common_widgets/orders_widget/order_card_widget.dart';
import '../../../../utils/app_strings.dart';
import '../../../core_components/common_widgets/app_error_message_widget.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/data_not_available_widget.dart';
import '../../provider_new_order/model/api/new_order_list_model.dart';
import '../bloc/provider_order_history_cubit/provider_order_history_cubit.dart';
import '../bloc/provider_order_history_cubit/provider_order_history_state.dart';

class OrderHistoryTabWidget extends StatefulWidget {
  static const String routeName = "/OrderHistoryTabWidget";
  final bool isFromDrawer;

  const OrderHistoryTabWidget({
    Key? key,
    this.isFromDrawer = false,
  }) : super(key: key);

  @override
  State<OrderHistoryTabWidget> createState() => _OrderHistoryTabWidgetState();
}

class _OrderHistoryTabWidgetState extends State<OrderHistoryTabWidget> {
  late ProviderOrderHistoryCubit providerOrderHistoryCubit;
  @override
  void initState() {
    providerOrderHistoryCubit = ProviderOrderHistoryCubit();
    providerOrderHistoryCubit.fetchProviderOrderHistory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      isAppBarShow: widget.isFromDrawer,
      appTitle: AppStrings.orderHistory,
      child: BlocBuilder<ProviderOrderHistoryCubit, ProviderOrderHistoryState>(
          bloc: providerOrderHistoryCubit,
          builder: (ctx, state) {
            if (state is ProviderOrderHistoryErrorState) {
              return AppErrorMessageWidget(
                errorMessage: state.errorMessage,
                textColor: state.bgColor,
              );
            } else if (state is ProviderOrderHistoryLoadedState) {
              List<Quotes> orderHistory = state.list;
              return orderHistory.isEmpty
                  ? const DataNotAvailableWidget()
                  : Padding(
                      padding: EdgeInsets.only(left: 20.sw, right: 20.sw),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 24.sh),
                        physics: const ClampingScrollPhysics(),
                        itemCount: orderHistory.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return OrderCardWidget(
                            scheduleOrder: orderHistory[index],
                          );
                        },
                      ),
                    );
            }
            return const AppLoadingWidget();
          }),
    );
  }
}
