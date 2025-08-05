import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/bloc/quotes_bloc/quotes_cubit.dart';
import '../../../core/services/bloc/quotes_bloc/quotes_state.dart';
import '../../../core/services/stripe/payment_success_dialog_widget.dart';
import '../../../core/services/stripe/stripe_payment_cubit.dart';
import '../../../core/services/stripe/stripe_payment_state.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_utils.dart';
import '../../customer_home/ui/customer_home_screen.dart';
import '../../provider_home/ui/provider_home_screen.dart';
import '../../provider_new_order/model/api/new_order_list_model.dart';
import '../../summary/ui/customer_summary_screen.dart';
import '../bloc/order_end_cubit/order_end_cubit.dart';
import '../bloc/order_end_cubit/order_end_state.dart';
import 'widgets/alert_dialog_for_invoice_widget.dart';
import 'widgets/order_detail_started_booking_widget.dart';

class StartedBookingDetailScreen extends StatefulWidget {
  static const String routeName = "/StartedBookingDetailScreen";
  final Quotes scheduleOrder;

  const StartedBookingDetailScreen({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  State<StartedBookingDetailScreen> createState() =>
      _StartedBookingDetailScreenState();
}

class _StartedBookingDetailScreenState
    extends State<StartedBookingDetailScreen> {
  late OrderEndCubit orderEndCubit;
  late QuotesCubit quotesCubit;

  late StripePaymentCubit stripePaymentCubit;
  bool isLoading = false;
  bool isLoadingForPayment = false;

  @override
  void initState() {
    orderEndCubit = OrderEndCubit();
    quotesCubit = BlocProvider.of<QuotesCubit>(context, listen: false);
    quotesCubit.quoteDetails(quoteUniqueId: widget.scheduleOrder.orderNumber);

    stripePaymentCubit = StripePaymentCubit();
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
      appTitle: widget.scheduleOrder.orderNumber,
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
            Quotes quotes = state.quotes;
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 3,
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
                        // child: const UsedTimeWidget(),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: AppUtils.deviceWidth,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: OrderDetailStartedBookingWidget(scheduleOrder: quotes),
                ),
                bottomWidgetButton(quotes: quotes),
              ],
            );
          }
          return const AppLoadingWidget();
        },
      ),
    );
  }

  Widget bottomWidgetButton({required Quotes quotes}) {
    return BlocListener<OrderEndCubit, OrderEndState>(
      bloc: orderEndCubit,
      listener: (ctx, state) {
        if (state is OrderEndLoadingState) {
          setState(() => isLoading = true);
        } else if (state is OrderEndErrorState) {
          setState(() => isLoading = false);
          AppUtils.showSnackBar(state.errorMessage, bgColor: state.bgColor);
        } else if (state is OrderEndLoadedState) {
          setState(() => isLoading = false);
          quotesCubit.quoteDetails(quoteUniqueId: quotes.orderNumber);
          AppUtils.showSnackBar(state.message, bgColor: state.bgColor);
          /*Future.delayed(
            const Duration(seconds: 1),
            () => Navigator.pushReplacementNamed(
                context, FeedbackScreen.routeName,
                arguments: widget.scheduleOrder),
          );*/
        }
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 24.sh, left: 20.sw, right: 20.sw),
          child: isLoading
              ? SizedBox(
                  height: 48.sh,
                  child: const AppLoadingWidget(),
                )
              : !AppUtils.getIsRoleCustomer()
                  ? BottomButtonWidget(
                      isDisable: (quotes.status == AppConstants.paymentPending),
                      buttonTitle:
                          (quotes.status == AppConstants.paymentPending)
                              ? AppStrings.paymentPending
                              : AppStrings.endBooking,
                      buttonBGColor: AppColors.black,
                      onPressed: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black45,
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder: (BuildContext buildContext,
                              Animation animation,
                              Animation secondaryAnimation) {
                            return AlertDialogForInvoiceWidget(
                              onPressedOk: () => Navigator.pop(context),
                              onPressedContinue: () {
                                Navigator.pop(context);
                                orderEndCubit.orderEnd(quotes.orderNumber);
                              },
                            );
                          },
                        );
                      },
                    )
                  : (AppUtils.getIsRoleCustomer() &&
                          (quotes.status == AppConstants.paymentPending ||
                              quotes.status == AppConstants.started))
                      ? BlocListener<StripePaymentCubit, StripePaymentState>(
                          bloc: stripePaymentCubit,
                          listener: (ctx, state) {
                            if (state is StripeLoadingState) {
                              setState(() => isLoadingForPayment = true);
                            } else if (state is StripeErrorState) {
                              setState(() => isLoadingForPayment = false);
                              AppUtils.showSnackBar(state.errorMessage,
                                  bgColor: state.bgColor);
                            } else if (state is StripeLoadedState) {
                              setState(() => isLoadingForPayment = false);
                              AppUtils.debugPrint(
                                  "paymentStatusModel => ${state.paymentStatusModel}");

                              showGeneralDialog(
                                context: context,
                                barrierDismissible: false,
                                barrierLabel: MaterialLocalizations.of(context)
                                    .modalBarrierDismissLabel,
                                barrierColor: Colors.black45,
                                transitionDuration:
                                    const Duration(milliseconds: 200),
                                pageBuilder: (BuildContext buildContext,
                                    Animation animation,
                                    Animation secondaryAnimation) {
                                  return PaymentSuccessDialogWidget(
                                    paymentStatusModel:
                                        state.paymentStatusModel,
                                    onPressed: () =>
                                        Navigator.pushReplacementNamed(context,
                                            CustomerSummaryScreen.routeName,
                                            arguments: quotes),
                                  );
                                },
                              );
                            }
                          },
                          child: isLoadingForPayment
                              ? const AppLoadingWidget()
                              : BottomButtonWidget(
                                  isSvg: true,
                                  isDisable:
                                      quotes.status == AppConstants.started,
                                  buttonTitle: AppStrings.payNow,
                                  buttonBGColor:
                                      (quotes.status == AppConstants.started)
                                          ? null
                                          : AppColors.green,
                                  onPressed: () {
                                    stripePaymentCubit.makePayment(
                                        quotes.totalBill.toStringAsFixed(2),
                                        quotes);
                                  },
                                ),
                        )
                      : const Offstage(),
        ),
      ),
    );
  }
}
