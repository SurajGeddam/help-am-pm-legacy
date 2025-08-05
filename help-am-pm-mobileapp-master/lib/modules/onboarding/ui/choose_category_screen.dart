import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core_components/common_models/key_value_model.dart';
import '../../../core_components/common_widgets/app_error_message_widget.dart';
import '../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../core_components/common_widgets/app_scaffold_widget.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_utils.dart';
import '../../address/model/save_address_model/request_body/save_address_req_body_model.dart';
import '../bloc/category_cubit/category_cubit.dart';
import '../bloc/category_cubit/category_state.dart';
import '../model/category_model/api/category_model.dart';
import 'widgets/choose_category_widgets/choose_category_list_view_widget.dart';

class ChooseCategoryScreen extends StatefulWidget {
  static const String routeName = "/ChooseCategoryScreen";
  final SaveAddressReqBodyModel? addressModel;
  final KeyValueModel? categoryObj;

  const ChooseCategoryScreen({
    Key? key,
    this.addressModel,
    this.categoryObj,
  }) : super(key: key);

  @override
  State<ChooseCategoryScreen> createState() => _ChooseCategoryScreenState();
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
  late CategoryCubit categoryCubit;

  @override
  void initState() {
    categoryCubit = CategoryCubit();
    categoryCubit.fetchCategory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appTitle: AppStrings.chooseCategory,
      child: BlocBuilder<CategoryCubit, CategoryState>(
          bloc: categoryCubit,
          builder: (context, state) {
            if (state is CategoryLoadedState) {
              List<CategoryModel> newList = state.list;
              return Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    /*const ScreenHeaderWidget(
                        headerString: AppStrings.selectYourServiceCategory),*/
                    ChooseCategoryListViewWidget(
                      list: newList,
                      addressModel: widget.addressModel,
                      categoryObj: widget.categoryObj,
                    ),
                    SizedBox(height: 24.sh),
                  ],
                ),
              );
            } else if (state is CategoryErrorState) {
              return AppErrorMessageWidget(
                errorMessage: state.errorMessage,
              );
            }
            return const AppLoadingWidget();
          }),
    );
  }
}
