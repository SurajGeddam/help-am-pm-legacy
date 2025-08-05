import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core_components/common_models/key_value_model.dart';
import '../../../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_mock_list.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../feedback/bloc/feedback_cubit.dart';
import '../../../feedback/bloc/feedback_state.dart';
import '../../../feedback/ui/widgets/comment_box_widget.dart';
import '../../../feedback/ui/widgets/rating_with_header_widget.dart';
import '../../../provider_new_order/model/api/new_order_list_model.dart';
import '../thanks_feedback_screen.dart';

class CustomerFeedbackWidget extends StatefulWidget {
  final Quotes quotes;

  const CustomerFeedbackWidget({
    Key? key,
    required this.quotes,
  }) : super(key: key);

  @override
  State<CustomerFeedbackWidget> createState() => _CustomerFeedbackWidgetState();
}

class _CustomerFeedbackWidgetState extends State<CustomerFeedbackWidget> {
  TextEditingController textController = TextEditingController();
  List<KeyValueModel> list = [];
  KeyValueModel? selectedComment;

  late FeedbackCubit feedbackCubit;
  double rating = 0.0;
  bool isLoading = false;

  void onSelect(KeyValueModel obj) {
    setState(() {
      for (var e in list) {
        e.isSelected = false;
      }
      obj.isSelected = true;
      selectedComment = obj;
    });
  }

  @override
  void initState() {
    feedbackCubit = FeedbackCubit();
    list = AppMockList.feedbackNoteList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Container(
          height: AppUtils.deviceHeight * 0.75,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 28.sh),
              Text(
                AppStrings.howDidWeDo,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 26.fs,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.sh),
              Text(
                AppStrings.rateYourServiceWithRoberto,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 14.fs,
                  fontWeight: FontWeight.w400,
                  color: AppColors.appMediumGrey,
                ),
                textAlign: TextAlign.center,
              ),
              RatingWithHeaderWidget(
                  isShowHeader: false, onPressed: (value) => rating = value),

              /// Todo: for future sprint
              /*Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 8.sw, vertical: 16.sh),
                child: Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 16.0,
                  spacing: 10.0,
                  children: list
                      .map((e) => GestureDetector(
                            onTap: () => onSelect(e),
                            child: Container(
                              height: 40.sh,
                              width: 110.sw,
                              decoration: BoxDecoration(
                                color: e.isSelected
                                    ? AppColors.appYellow
                                    : AppColors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.r)),
                                border: e.isSelected
                                    ? null
                                    : Border.all(color: AppColors.appDarkGrey),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                e.value,
                                style: AppTextStyles.defaultTextStyle.copyWith(
                                  fontSize: 10.fs,
                                  fontWeight: FontWeight.w700,
                                  color: e.isSelected
                                      ? AppColors.white
                                      : AppColors.black,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),*/
              CommentBoxWidget(
                textController: textController,
                hintText: AppStrings.leaveAComment,
                textBoxHeight: 150.sh,
              ),
              const Spacer(),
              Padding(
                padding:
                    EdgeInsets.only(bottom: 24.sh, left: 20.sw, right: 20.sw),
                child: BlocListener<FeedbackCubit, FeedbackState>(
                  bloc: feedbackCubit,
                  listener: (ctx, state) {
                    if (state is FeedbackLoadingState) {
                      setState(() => isLoading = true);
                    } else if (state is FeedbackErrorState) {
                      setState(() => isLoading = false);
                      AppUtils.showSnackBar(state.errorMessage,
                          bgColor: state.bgColor);
                    } else if (state is FeedbackLoadedState) {
                      setState(() => isLoading = false);
                      AppUtils.showSnackBar(state.message,
                          bgColor: state.bgColor);
                      Future.delayed(
                        const Duration(seconds: 1),
                        () => Navigator.of(context).pushNamedAndRemoveUntil(
                            ThanksFeedbackScreen.routeName,
                            (Route<dynamic> route) => false),
                      );
                    }
                  },
                  child: isLoading
                      ? SizedBox(
                          height: 48.sh,
                          child: const AppLoadingWidget(),
                        )
                      : BottomButtonWidget(
                          isDisable: (selectedComment == null &&
                              textController.text.isEmpty),
                          buttonTitle: AppStrings.submit,
                          buttonBGColor: AppColors.black,
                          onPressed: () {
                            feedbackCubit.submitFeedback(
                              rating: rating,
                              feedback: textController.text,
                              givenBy:
                                  widget.quotes.quoteProvider?.uniqueId ?? "0",
                              selectedComment: selectedComment,
                            );
                          }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
