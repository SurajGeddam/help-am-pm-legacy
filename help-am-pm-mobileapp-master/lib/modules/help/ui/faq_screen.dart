import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:helpampm/modules/help/model/faq_model.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_widgets/app_error_message_widget.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../bloc/faq_cubit/faq_cubit.dart';
import '../bloc/faq_cubit/faq_state.dart';

class FaqScreen extends StatefulWidget {
  static const String routeName = "/FaqScreen";

  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late FaqCubit faqCubit;

  @override
  void initState() {
    faqCubit = FaqCubit();
    faqCubit.fetchFaqResponse();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.faqs,
      child: BlocBuilder<FaqCubit, FaqState>(
          bloc: faqCubit,
          builder: (ctx, state) {
            if (state is FaqErrorState) {
              return AppErrorMessageWidget(
                errorMessage: state.errorMessage,
                textColor: state.bgColor,
              );
            } else if (state is FaqLoadedState) {
              List<FaqModel> faqModelList = state.faqModelList;
              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: faqModelList.length,
                itemBuilder: (BuildContext ctx, int index) {
                  FaqModel faqObject = faqModelList[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.sw),
                    child: GFAccordion(
                      textStyle: TextStyle(
                        fontSize: 15.fs,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMediumColorOnForm,
                      ),
                      title: faqObject.question,
                      content: faqObject.answer,
                    ),
                  );
                },
              );
            }
            return const AppLoadingWidget();
          }),
    );
  }
}
