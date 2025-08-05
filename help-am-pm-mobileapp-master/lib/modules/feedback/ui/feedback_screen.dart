import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/modules/provider_new_order/model/api/new_order_list_model.dart';
import 'package:helpampm/modules/summary/ui/thanks_feedback_screen.dart';
import 'package:helpampm/utils/app_text_styles.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../provider_orders/ui/widgets/profile_widget.dart';
import '../bloc/feedback_cubit.dart';
import '../bloc/feedback_state.dart';
import 'widgets/comment_box_widget.dart';
import 'widgets/rating_with_header_widget.dart';

class FeedbackScreen extends StatefulWidget {
  static const String routeName = "/FeedbackScreen";
  final Quotes scheduleOrder;

  const FeedbackScreen({
    Key? key,
    required this.scheduleOrder,
  }) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController textController = TextEditingController();
  late FeedbackCubit feedbackCubit;
  double rating = 0.0;
  bool isLoading = false;

  @override
  void initState() {
    feedbackCubit = FeedbackCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: widget.scheduleOrder.orderNumber,
      child: BlocListener<FeedbackCubit, FeedbackState>(
        bloc: feedbackCubit,
        listener: (ctx, state) {
          if (state is FeedbackLoadingState) {
            setState(() => isLoading = true);
          } else if (state is FeedbackErrorState) {
            setState(() => isLoading = false);
            AppUtils.showSnackBar(state.errorMessage, bgColor: state.bgColor);
          } else if (state is FeedbackLoadedState) {
            setState(() => isLoading = false);
            AppUtils.showSnackBar(state.message, bgColor: state.bgColor);
            Future.delayed(
              const Duration(seconds: 1),
              () => Navigator.of(context).pushNamedAndRemoveUntil(
                  ThanksFeedbackScreen.routeName,
                  (Route<dynamic> route) => false),
            );
          }
        },
        child: ListView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.sh),
              child: ProfileWidget(scheduleOrder: widget.scheduleOrder),
            ),
            Divider(
              height: 1.sh,
              thickness: 1.sh,
              color: AppColors.dividerColor,
            ),
            RatingWithHeaderWidget(onPressed: (value) => rating = value),
            CommentBoxWidget(textController: textController),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 36.sh, horizontal: 20.sw),
              child: isLoading
                  ? SizedBox(
                      height: 48.sh,
                      child: const AppLoadingWidget(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: BottomButtonWidget(
                            buttonTitle: AppStrings.cancel,
                            buttonTitleStyle:
                                AppTextStyles.defaultTextStyle.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.fs,
                            ),
                            isOutlineBtn: true,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(width: 20.sw),
                        Expanded(
                          child: BottomButtonWidget(
                            buttonTitle: AppStrings.submit,
                            buttonBGColor: AppColors.black,
                            onPressed: () => feedbackCubit.submitFeedback(
                                rating: rating,
                                feedback: textController.text,
                                givenBy: widget.scheduleOrder.customerUniqueId),
                          ),
                        )
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
