import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_widgets/app_error_message_widget.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/orders_widget/order_card_widget.dart';
import '../../../utils/app_enum.dart';
import '../../../utils/app_strings.dart';
import '../../provider_new_order/model/api/new_order_list_model.dart';
import '../bloc/ongoing_order_cubit/ongoing_order_cubit.dart';
import '../bloc/ongoing_order_cubit/ongoing_order_state.dart';

class OngoingOrderListScreen extends StatefulWidget {
  static const String routeName = "/OngoingOrderListScreen";

  const OngoingOrderListScreen({Key? key}) : super(key: key);

  @override
  State<OngoingOrderListScreen> createState() => _OngoingOrderListScreenState();
}

class _OngoingOrderListScreenState extends State<OngoingOrderListScreen> {
  late OngoingOrderCubit ongoingOrderCubit;

  @override
  void initState() {
    ongoingOrderCubit =
        BlocProvider.of<OngoingOrderCubit>(context, listen: false);
    ongoingOrderCubit.fetchOngoingOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      isAppBarShow: true,
      appTitle: AppStrings.newOrder,
      child: BlocBuilder<OngoingOrderCubit, OngoingOrderState>(
          bloc: ongoingOrderCubit,
          builder: (ctx, state) {
            if (state is OngoingOrderErrorState) {
              return AppErrorMessageWidget(
                errorMessage: state.errorMessage,
                textColor: state.bgColor,
              );
            } else if (state is OngoingOrderLoadedState) {
              List<Quotes> orderList = state.list;
              return Padding(
                padding:
                    EdgeInsets.only(left: 20.sw, right: 20.sw, bottom: 24.sh),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  itemCount: orderList.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return OrderCardWidget(
                      scheduleOrder: orderList[index],
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
