import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/customer_home/ui/customer_home_screen.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core/services/bloc/quotes_bloc/quotes_cubit.dart';
import '../../../core/services/bloc/quotes_bloc/quotes_state.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../provider_home/ui/provider_home_screen.dart';
import '../../provider_new_order/model/api/new_order_list_model.dart';
import '../../started_booking/ui/started_booking_detail_screen.dart';
import '../bloc/order_start_cubit/order_start_cubit.dart';
import '../bloc/order_start_cubit/order_start_state.dart';
import 'widgets/call_customer_widget.dart';
import 'widgets/profile_widget.dart';
import 'widgets/service_address_widget.dart';
import 'widgets/service_info_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String routeName = "/OrderDetailsWidget";
  final Quotes scheduleOrder;

  const OrderDetailsScreen({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late OrderStartCubit orderStartCubit;
  late QuotesCubit quotesCubit;

  Quotes scheduleOrderPrivate = Quotes();
  bool isLoading = false;

  @override
  void initState() {
    orderStartCubit = OrderStartCubit();
    scheduleOrderPrivate = widget.scheduleOrder;

    quotesCubit = BlocProvider.of<QuotesCubit>(context, listen: false);
    quotesCubit.quoteDetails(quoteUniqueId: scheduleOrderPrivate.orderNumber);

    super.initState();
  }

  onPressBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushReplacementNamed(
          context,
          AppUtils.getIsRoleCustomer()
              ? CustomerHomeScreen.routeName
              : ProviderHomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.orderDetails,
      onTapBack: onPressBack,
      child: BlocConsumer<QuotesCubit, QuotesState>(
        bloc: quotesCubit,
        listener: (ctx, state) {
          if (state is QuotesErrorState) {
            setState(() => isLoading = false);
            AppUtils.showSnackBar(state.errorMessage, bgColor: state.bgColor);
          }
        },
        builder: (ctx, state) {
          if (state is QuotesLoadedState) {
            scheduleOrderPrivate = state.quotes;
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    width: AppUtils.deviceWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30.sh, left: 20.sw),
                          child: Text(
                            AppStrings.orderId,
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              fontSize: 16.fs,
                              fontWeight: FontWeight.w500,
                              color: AppColors.appMediumGrey,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.sh, left: 20.sw),
                          child: Text(
                            scheduleOrderPrivate.orderNumber,
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              fontSize: 18.fs,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 18.sh),
                          child: Divider(
                            height: 1.sh,
                            thickness: 5.sh,
                            color: AppColors.grey,
                          ),
                        ),
                        CallCustomerWidget(
                            phoneNumber: scheduleOrderPrivate.customerPhone),
                        Padding(
                          padding: EdgeInsets.only(top: 18.sh),
                          child: Divider(
                            height: 1.sh,
                            thickness: 5.sh,
                            color: AppColors.grey,
                          ),
                        ),
                        ServiceInfoWidget(scheduleOrder: scheduleOrderPrivate),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.sh),
                          child: Divider(
                            height: 1.sh,
                            thickness: 5.sh,
                            color: AppColors.grey,
                          ),
                        ),
                        ProfileWidget(scheduleOrder: scheduleOrderPrivate),
                        ServiceAddressWidget(
                            scheduleOrder: scheduleOrderPrivate),
                      ],
                    ),
                  ),
                ),
                BlocListener<OrderStartCubit, OrderStartState>(
                  bloc: orderStartCubit,
                  listener: (ctx, state) {
                    if (state is OrderStartLoadingState) {
                      setState(() => isLoading = true);
                    } else if (state is OrderStartErrorState) {
                      setState(() => isLoading = false);
                      AppUtils.showSnackBar(state.errorMessage,
                          bgColor: state.bgColor);
                    } else if (state is OrderStartLoadedState) {
                      setState(() => isLoading = false);
                      AppUtils.showSnackBar(state.message,
                          bgColor: state.bgColor);
                      Future.delayed(
                        const Duration(seconds: 1),
                        () => Navigator.pushReplacementNamed(
                            context, StartedBookingDetailScreen.routeName,
                            arguments: scheduleOrderPrivate),
                      );
                    }
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 24.sh, left: 20.sw, right: 20.sw),
                      child: isLoading
                          ? SizedBox(
                              height: 48.sh,
                              child: const AppLoadingWidget(),
                            )
                          : !AppUtils.getIsRoleCustomer()
                              ? BottomButtonWidget(
                                  buttonTitle: AppStrings.startBooking,
                                  buttonBGColor: AppColors.black,
                                  onPressed: () => orderStartCubit.orderStart(
                                      scheduleOrderPrivate.orderNumber),
                                )
                              : const Offstage(),
                    ),
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
