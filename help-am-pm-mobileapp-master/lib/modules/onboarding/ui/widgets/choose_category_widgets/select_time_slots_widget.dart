import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../../utils/app_utils.dart';
import '../../../bloc/save_category_cubit/save_category_cubit.dart';
import '../../../bloc/save_category_cubit/save_category_state.dart';
import '../../../model/category_model/api/category_model.dart';
import '../../company_details_screen.dart';
import 'choose_category_time_slots_widget.dart';

class SelectTimeSlotsWidget extends StatefulWidget {
  final CategoryModel obj;

  const SelectTimeSlotsWidget({
    Key? key,
    required this.obj,
  }) : super(key: key);

  @override
  State<SelectTimeSlotsWidget> createState() => _SelectTimeSlotsWidgetState();
}

class _SelectTimeSlotsWidgetState extends State<SelectTimeSlotsWidget> {
  late SaveCategoryCubit saveCategoryCubit;
  TextEditingController textController = TextEditingController();
  List<Timeslots> list = [];
  bool isLoading = false;

  void onPressed(Timeslots obj) {
    setState(() => obj.isSelected = !obj.isSelected);
  }

  @override
  void initState() {
    saveCategoryCubit = SaveCategoryCubit();
    list = widget.obj.timeslots ?? [];
    for (var element in list) {
      element.isSelected = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveCategoryCubit, SaveCategoryState>(
      bloc: saveCategoryCubit,
      listener: (ctx, state) {
        if (state is SaveCategoryLoadingState) {
          setState(() => isLoading = true);
        } else if (state is SaveCategoryErrorState) {
          setState(() => isLoading = false);
          AppUtils.showSnackBar(state.errorMessage);
        } else if (state is SaveCategoryLoadedState) {
          AppUtils.showSnackBar(state.message, bgColor: AppColors.grassGreen);
          Future.delayed(Duration.zero, () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(
                context, CompanyDetailsScreen.routeName);
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
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
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                isLoading
                    ? const Offstage()
                    : ListView(
                        shrinkWrap: false,
                        padding: EdgeInsets.zero,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          /// Hrs of Operation
                          Padding(
                            padding: EdgeInsets.only(
                                top: 32.sh,
                                bottom: 20.sh,
                                left: 40.sw,
                                right: 40.sw),
                            child: Text(
                              AppStrings.hrsOfOperation,
                              style: AppTextStyles.defaultTextStyle.copyWith(
                                fontSize: 18.fs,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ChooseCategoryTimeSlotWidget(
                            categoryModel: widget.obj,
                            onTap: (value) => onPressed(value),
                          ),
                        ],
                      ),
                isLoading
                    ? const AppLoadingWidget()
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: 24.sh, left: 20.sw, right: 20.sw),
                          child: BottomButtonWidget(
                              isDisable: list.isEmpty,
                              buttonTitle: AppStrings.continueString,
                              buttonBGColor: AppColors.black,
                              onPressed: savedCategory),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void savedCategory() {
    List<Timeslots> tempList = [];
    for (var element in list) {
      if (element.isSelected) {
        tempList.add(Timeslots(id: element.id));
      }
    }
    widget.obj.timeslots = tempList;
    saveCategoryCubit.saveSelectedCategory(widget.obj);
  }
}
