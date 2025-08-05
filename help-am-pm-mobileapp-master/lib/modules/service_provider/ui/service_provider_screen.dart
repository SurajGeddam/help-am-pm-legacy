import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helpampm/modules/ongoing_service/ui/ongoing_service_screen.dart';

import '../../../core/services/bloc/quotes_bloc/quotes_cubit.dart';
import '../../../core/services/bloc/quotes_bloc/quotes_state.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/app_utils.dart';
import '../../customer_booking/ui/widgets/list_view_with_header_widget.dart';
import '../../customer_home/ui/customer_home_screen.dart';
import '../../onboarding/model/category_model/api/category_model.dart';
import '../../provider_new_order/model/api/new_order_list_model.dart';
import '../bloc/cancel_order_cubit/cancel_order_cubit.dart';
import '../bloc/cancel_order_cubit/cancel_order_state.dart';
import 'widgets/provider_profile_container_widget.dart';

class ServiceProviderScreen extends StatefulWidget {
  static const String routeName = "/ServiceProviderScreen";
  final Quotes scheduleOrder;

  const ServiceProviderScreen({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  late QuotesCubit quotesCubit;
  late Quotes quotes;

  late CancelOrderCubit cancelOrderCubit;
  bool isLoading = false;

  onPressBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushReplacementNamed(context, CustomerHomeScreen.routeName);
    }
  }

  String displayTimeSlot(Timeslots timeSlot) {
    return "${timeSlot.startTime} to ${timeSlot.endTime}";
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
  void initState() {
    quotesCubit = BlocProvider.of<QuotesCubit>(context, listen: false);
    quotesCubit.quoteDetails(quoteUniqueId: widget.scheduleOrder.orderNumber);

    cancelOrderCubit = CancelOrderCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.serviceProvider,
      onTapBack: onPressBack,
      child: BlocBuilder<QuotesCubit, QuotesState>(
          bloc: quotesCubit,
          builder: (_, state) {
            if (state is QuotesLoadedState) {
              quotes = state.quotes;
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  SingleChildScrollView(
                    child: SizedBox(
                      height: AppUtils.deviceHeight,
                      width: AppUtils.deviceWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 20.sh, bottom: 32.sh),
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.help.toUpperCase(),
                              style: AppTextStyles.defaultTextStyle.copyWith(
                                fontSize: 25.fs,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                            ),
                          ),
                          ProviderProfileContainerWidget(quotes: quotes),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.sw, vertical: 30.sh),
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8.r)),
                            child: ListViewWithHeaderWidget(
                                headerString: AppStrings.note,
                                list: [
                                  AppStrings.noteMsg0.replaceAll(
                                      "DOLLAR",
                                      quotes.totalBill
                                          .toStringAsFixed(2)
                                          .toString()),
                                  AppStrings.noteMsg1,
                                ]),
                          ),
                          Divider(
                            height: 60.sh,
                            thickness: 8.sh,
                            color: AppColors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.sw),
                            child: Text(
                              AppStrings.arrivingTime,
                              style: AppTextStyles.defaultTextStyle.copyWith(
                                fontSize: 16.fs,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 14.sh),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.sw),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.timeIconSvg,
                                  height: 14.sh,
                                  width: 14.sw,
                                  color: AppColors.appDarkGrey,
                                ),
                                SizedBox(width: 8.sw),
                                Text(
                                  displayTimeSlot(quotes.timeslot!),
                                  style:
                                      AppTextStyles.defaultTextStyle.copyWith(
                                    fontSize: 12.fs,
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.black,
                                  ),
                                  textAlign: TextAlign.left,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  BlocListener<CancelOrderCubit, CancelOrderState>(
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
                            () => Navigator.of(context).pushNamedAndRemoveUntil(
                                CustomerHomeScreen.routeName,
                                (Route<dynamic> route) => true));
                        return;
                      }
                    },
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: 24.sh, left: 20.sw, right: 20.sw),
                        child: isLoading
                            ? const AppLoadingWidget()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: BottomButtonWidget(
                                      isSvg: true,
                                      buttonTitle: AppStrings.cancel,
                                      buttonBGColor: AppColors.red,
                                      onPressed: () =>
                                          showAlert(context, quotes),
                                    ),
                                  ),
                                  SizedBox(width: 16.sh),
                                  Expanded(
                                    child: BottomButtonWidget(
                                      isSvg: true,
                                      buttonTitle: AppStrings.next,
                                      buttonBGColor: AppColors.appGreen,
                                      onPressed: () => Navigator.pushNamed(
                                          context,
                                          OngoingServiceScreen.routeName,
                                          arguments: {"quotes": quotes}),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const AppLoadingWidget();
          }),
    );
  }
}
