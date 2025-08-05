import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../../core_components/common_widgets/app_loading_widget.dart';
import '../../../../core_components/common_widgets/app_text_field_form_widget.dart';
import '../../../../core_components/common_widgets/app_text_label_widget.dart';
import '../../../../core_components/common_widgets/bottom_button_widget.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_enum.dart';
import '../../../../utils/app_strings.dart';
import '../../bloc/add_remove_item_bloc/add_remove_item_bloc.dart';
import '../../bloc/add_remove_item_bloc/add_remove_item_event.dart';
import '../../bloc/add_remove_item_bloc/add_remove_item_state.dart';
import '../../model/item_details_model.dart';

class AddNewItemWithPriceWidget extends StatefulWidget {
  final int itemId;
  final String quoteUniqueId;
  final Function callBack;

  const AddNewItemWithPriceWidget({
    Key? key,
    required this.itemId,
    required this.quoteUniqueId,
    required this.callBack,
  }) : super(key: key);

  @override
  State<AddNewItemWithPriceWidget> createState() =>
      _AddNewItemWithPriceWidgetState();
}

class _AddNewItemWithPriceWidgetState extends State<AddNewItemWithPriceWidget> {
  TextEditingController textController = TextEditingController();
  TextEditingController textPriceController = TextEditingController();

  late AddRemoveItemBloc addRemoveItemBloc;
  bool isLoading = false;

  @override
  void initState() {
    addRemoveItemBloc =
        BlocProvider.of<AddRemoveItemBloc>(context, listen: false);
    super.initState();
  }

  navigateTo(BuildContext context, ItemDetails itemDetails) {
    Future.delayed(Duration.zero, () {
      Navigator.pop(context);
      widget.callBack(itemDetails);
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocListener<AddRemoveItemBloc, AddRemoveItemState>(
        bloc: addRemoveItemBloc,
        listener: (ctx, state) {
          if (state is AddRemoveItemLoadingState) {
            setState(() => isLoading = true);
          } else if (state is AddRemoveItemValidState) {
            addRemoveItemBloc.add(AddRemoveItemSubmittedEvent(
              quoteItemId: widget.itemId,
              quoteUniqueId: widget.quoteUniqueId,
              description: textController.text,
              itemPrice: textPriceController.text,
            ));
          } else if (state is AddRemoveItemErrorState) {
            setState(() => isLoading = false);
            AppUtils.showSnackBar(state.errorMessage);
          } else if (state is AddRemoveItemCompleteState) {
            setState(() => isLoading = false);
            navigateTo(context, state.itemDetails);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.transparent,
          body: Center(
            child: Container(
              height: AppUtils.deviceHeight * 0.40,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.sh),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              AppStrings.close,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.sh),

                        /// Item name
                        const AppTextLabelFormWidget(
                          labelText: AppStrings.description,
                          isMandatory: true,
                        ),
                        AppTextFieldFormWidget(
                          textController: textController,
                          maxLength: 50,
                        ),
                        SizedBox(height: 8.sh),

                        /// Item value
                        const AppTextLabelFormWidget(
                          labelText: AppStrings.price,
                          isMandatory: true,
                        ),
                        AppTextFieldFormWidget(
                          textController: textPriceController,
                          maxLength: 7,
                          textFormFieldType: TextFormFieldType.price,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 24.sh, left: 20.sw, right: 20.sw),
                      child: isLoading
                          ? const AppLoadingWidget()
                          : BottomButtonWidget(
                              buttonTitle: AppStrings.save,
                              buttonBGColor: AppColors.black,
                              onPressed: () {
                                addRemoveItemBloc
                                    .add(AddRemoveItemValidationEvent(
                                  itemValue: textController.text,
                                  priceValue: textPriceController.text,
                                ));
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
