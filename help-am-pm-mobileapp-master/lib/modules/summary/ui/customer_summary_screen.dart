import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core_components/common_widgets/app_loading_widget.dart';
import 'package:helpampm/modules/provider_new_order/model/api/new_order_list_model.dart';

import '../../../core/services/bloc/quotes_bloc/quotes_cubit.dart';
import '../../../core/services/bloc/quotes_bloc/quotes_state.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/app_utils.dart';
import '../../provider_orders/ui/widgets/pricing_details_widget.dart';
import 'widgets/customer_feedback_widget.dart';
import 'widgets/first_card_widget.dart';
import 'widgets/column_key_value_widget.dart';

class CustomerSummaryScreen extends StatefulWidget {
  static const String routeName = "/CustomerSummaryScreen";
  final Quotes quotes;

  const CustomerSummaryScreen({
    Key? key,
    required this.quotes,
  }) : super(key: key);

  @override
  State<CustomerSummaryScreen> createState() => _CustomerSummaryScreenState();
}

class _CustomerSummaryScreenState extends State<CustomerSummaryScreen> {
  TextEditingController textController = TextEditingController();
  late QuotesCubit quotesCubit;

  @override
  void initState() {
    quotesCubit = BlocProvider.of<QuotesCubit>(context, listen: false);
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AppScaffoldWidget(
          appTitle: AppStrings.summary,
          isBackShow: false,
          child: BlocBuilder<QuotesCubit, QuotesState>(
            bloc: quotesCubit,
            builder: (_, state) {
              if (state is QuotesLoadedState) {
                Quotes quotes = state.quotes;
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ListView(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: [
                        FirstCardWidget(quotes: quotes),
                        Padding(
                          padding: EdgeInsets.only(top: 16.sh, left: 20.sw),
                          child: Text(
                            AppStrings.bookingDetails,
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              fontSize: 18.fs,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 26.sh),
                        ColumnKeyValueWidget(
                          header: AppStrings.service,
                          value: quotes.categoryName,
                        ),
                        SizedBox(height: 26.sh),
                        ColumnKeyValueWidget(
                          header: AppStrings.dateAndTime,
                          value:
                              "${AppUtils.getDateMMDDYYYY(quotes.updatedAt)} ",
                          isDateTime: true,
                          dateTimeString:
                              "${quotes.timeslot?.startTime} to ${quotes.timeslot?.endTime}",
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 28.sh),
                          child: Divider(
                            height: 1.sh,
                            thickness: 5.sh,
                            color: AppColors.dividerColor,
                          ),
                        ),
                        // const PricingDetailWidget(),
                        PricingDetailsWidget(scheduleOrder: quotes),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 60.sh,
                            bottom: 24.sh,
                            left: 20.sw,
                            right: 20.sw),
                        child: BottomButtonWidget(
                          buttonTitle: AppStrings.rateProviderService,
                          buttonBGColor: AppColors.black,
                          onPressed: () => bottomSheetWidget(context),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const AppLoadingWidget();
            },
          )),
    );
  }

  void bottomSheetWidget(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => CustomerFeedbackWidget(quotes: widget.quotes),
    );
  }
}
