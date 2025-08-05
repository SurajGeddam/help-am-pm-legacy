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
import '../../provider_new_order/model/api/new_order_list_model.dart';
import '../bloc/schedule_order_cubit/schedule_order_cubit.dart';
import '../bloc/schedule_order_cubit/schedule_order_state.dart';

class OrderScheduleTabWidget extends StatefulWidget {
  static const String routeName = "/OrderScheduleTabWidget";
  final bool isFromDrawer;

  const OrderScheduleTabWidget({
    Key? key,
    this.isFromDrawer = false,
  }) : super(key: key);

  @override
  State<OrderScheduleTabWidget> createState() => _OrderScheduleTabWidgetState();
}

class _OrderScheduleTabWidgetState extends State<OrderScheduleTabWidget> {
  late ScheduleOrderCubit scheduleOrderCubit;

  @override
  void initState() {
    scheduleOrderCubit =
        BlocProvider.of<ScheduleOrderCubit>(context, listen: false);
    scheduleOrderCubit.fetchScheduleOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      isAppBarShow: widget.isFromDrawer,
      appTitle: AppStrings.scheduleOrders,
      child: BlocBuilder<ScheduleOrderCubit, ScheduleOrderState>(
          bloc: scheduleOrderCubit,
          builder: (ctx, state) {
            if (state is ScheduleOrderErrorState) {
              return AppErrorMessageWidget(
                errorMessage: state.errorMessage,
                textColor: state.bgColor,
              );
            } else if (state is ScheduleOrderLoadedState) {
              List<Quotes> orderSchedule = state.list;

              return orderSchedule.isEmpty
                  ? const DataNotAvailableWidget()
                  : Padding(
                      padding: EdgeInsets.only(left: 20.sw, right: 20.sw),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const ClampingScrollPhysics(),
                        itemCount: orderSchedule.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return OrderCardWidget(
                            scheduleOrder: orderSchedule[index],
                            ordersType: OrdersType.schedule,
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
