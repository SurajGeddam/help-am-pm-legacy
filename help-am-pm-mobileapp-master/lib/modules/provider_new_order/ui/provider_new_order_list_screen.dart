import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_widgets/app_error_message_widget.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/data_not_available_widget.dart';
import '../../../core_components/common_widgets/orders_widget/order_card_widget.dart';
import '../../../utils/app_enum.dart';
import '../../../utils/app_strings.dart';
import '../bloc/new_order_cubit/new_order_cubit.dart';
import '../bloc/new_order_cubit/new_order_state.dart';
import '../model/api/new_order_list_model.dart';

class ProviderNewOrderListScreen extends StatefulWidget {
  static const String routeName = "/ProviderNewOrderListScreen";

  const ProviderNewOrderListScreen({Key? key}) : super(key: key);

  @override
  State<ProviderNewOrderListScreen> createState() =>
      _ProviderNewOrderListScreenState();
}

class _ProviderNewOrderListScreenState
    extends State<ProviderNewOrderListScreen> {
  late NewOrderCubit newOrderCubit;

  Future<void> _pullRefresh() async {
    newOrderCubit.fetchNewOrder();
  }

  @override
  void initState() {
    newOrderCubit = BlocProvider.of<NewOrderCubit>(context, listen: false);
    newOrderCubit.fetchNewOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      isAppBarShow: true,
      appTitle: AppStrings.newOrder,
      child: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: BlocBuilder<NewOrderCubit, NewOrderState>(
            bloc: newOrderCubit,
            builder: (ctx, state) {
              if (state is NewOrderErrorState) {
                return AppErrorMessageWidget(
                  errorMessage: state.errorMessage,
                  textColor: state.bgColor,
                );
              } else if (state is NewOrderLoadedState) {
                List<Quotes> scheduleOrdersList = state.list;
                return scheduleOrdersList.isEmpty
                    ? const DataNotAvailableWidget()
                    : Padding(
                        padding: EdgeInsets.only(
                            left: 20.sw, right: 20.sw, bottom: 24.sh),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          itemCount: scheduleOrdersList.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return OrderCardWidget(
                              scheduleOrder: scheduleOrdersList[index],
                              ordersType: OrdersType.schedule,
                            );
                          },
                        ),
                      );
              }
              return const AppLoadingWidget();
            }),
      ),
    );
  }
}
