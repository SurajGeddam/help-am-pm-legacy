import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_strings.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../utils/app_constant.dart';
import '../../customer_home/ui/customer_home_screen.dart';
import '../../provider_new_order/model/api/new_order_list_model.dart';
import '../../service_provider/bloc/cancel_order_cubit/cancel_order_cubit.dart';
import '../../service_provider/bloc/cancel_order_cubit/cancel_order_state.dart';
import 'widgets/pricing_details_widget.dart';
import 'widgets/service_details_widget.dart';
import 'widgets/service_to_widget.dart';

class OrderInformationScreen extends StatefulWidget {
  static const String routeName = "/OrderInformationWidget";
  final Quotes scheduleOrder;

  const OrderInformationScreen({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  State<OrderInformationScreen> createState() => _OrderInformationScreenState();
}

class _OrderInformationScreenState extends State<OrderInformationScreen> {
  late CancelOrderCubit cancelOrderCubit;
  bool isLoading = false;

  @override
  void initState() {
    cancelOrderCubit = CancelOrderCubit();
    super.initState();
  }

  void showAlert(BuildContext context, Quotes quotes) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppStrings.emptyString,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 14.fs,
                  fontWeight: FontWeight.w600,
                  color: AppColors.red,
                )),
            content: Text(AppStrings.areYouSure,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 14.fs,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                )),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppStrings.no,
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      fontSize: 14.fs,
                      fontWeight: FontWeight.w400,
                      color: Colors.blue,
                    )),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  cancelOrderCubit.cancelOrder(
                      quoteUniqueId: quotes.orderNumber);
                },
                child: Text(AppStrings.yes,
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      fontSize: 14.fs,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    )),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.orderInformation,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: AppUtils.deviceHeight,
          width: AppUtils.deviceWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.sw, top: 20.sh),
                child: Text(
                  AppStrings.orderId,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.sw, top: 8.sh),
                child: Text(
                  widget.scheduleOrder.orderNumber,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 18.fs,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 30.sh),
              Padding(
                padding: EdgeInsets.only(left: 20.sw),
                child: Text(
                  AppStrings.serviceTo,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              ServiceToWidget(scheduleOrder: widget.scheduleOrder),
              SizedBox(height: 30.sh),
              Padding(
                padding: EdgeInsets.only(left: 20.sw),
                child: Text(
                  AppStrings.serviceDetails,
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              ServiceDetailsWidget(scheduleOrder: widget.scheduleOrder),
              Padding(
                padding: EdgeInsets.only(top: 30.sw, left: 20.sw),
                child: Text(
                  "${AppUtils.getDatedMMM(widget.scheduleOrder.createdAt)}, ${AppUtils.getDateHhMmA(widget.scheduleOrder.createdAt)}",
                  style: AppTextStyles.defaultTextStyle.copyWith(
                    fontSize: 14.fs,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDarkColorOnForm,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.sh, bottom: 24.sh),
                child: Divider(
                  height: 1.sh,
                  thickness: 5.sh,
                  color: AppColors.grey,
                ),
              ),
              PricingDetailsWidget(scheduleOrder: widget.scheduleOrder),
              SizedBox(height: 24.sh),
              Padding(
                padding: EdgeInsets.only(
                    top: 24.sh, bottom: 24.sh, left: 20.sw, right: 20.sw),
                child: (widget.scheduleOrder.status == AppConstants.schedule)
                    ? BlocListener<CancelOrderCubit, CancelOrderState>(
                        bloc: cancelOrderCubit,
                        listener: (ctx, state) {
                          if (state is CancelOrderLoadingState) {
                            setState(() => isLoading = true);
                          } else if (state is CancelOrderErrorState) {
                            setState(() => isLoading = false);
                            AppUtils.showSnackBar(state.errorMessage,
                                bgColor: state.bgColor);
                          } else if (state is CancelOrderLoadedState) {
                            AppUtils.showSnackBar(state.message,
                                bgColor: state.bgColor);
                            Future.delayed(
                                const Duration(seconds: 1),
                                () => Navigator.of(context)
                                    .pushNamedAndRemoveUntil(
                                        CustomerHomeScreen.routeName,
                                        (Route<dynamic> route) => true));
                            return;
                          }
                        },
                        child: isLoading
                            ? const AppLoadingWidget()
                            : BottomButtonWidget(
                                isSvg: true,
                                buttonTitle: AppStrings.cancel,
                                buttonBGColor: AppColors.red,
                                onPressed: () =>
                                    showAlert(context, widget.scheduleOrder),
                              ),
                      )
                    : BottomButtonWidget(
                        buttonTitle: AppStrings.done,
                        buttonBGColor: AppColors.black,
                        onPressed: () => Navigator.pop(context),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
