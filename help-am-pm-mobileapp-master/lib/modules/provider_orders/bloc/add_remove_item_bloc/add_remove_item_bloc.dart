import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpampm/core/services/repositories/app_repository_validation.dart';

import '../../../../core/services/network/api_response.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../model/add_quote_item_model.dart';
import '../../model/item_details_model.dart';
import 'add_remove_item_event.dart';
import 'add_remove_item_state.dart';

class AddRemoveItemBloc extends Bloc<AddRemoveItemEvent, AddRemoveItemState> {
  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  AddRemoveItemBloc() : super(AddRemoveItemInitialState()) {
    String providerId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    on<AddRemoveItemValidationEvent>((event, emit) {
      if (event.itemValue.isEmpty) {
        emit(AddRemoveItemErrorState(AppStrings.pleaseEnterDescription));
      } else if (event.priceValue.isEmpty) {
        emit(AddRemoveItemErrorState(AppStrings.pleaseEnterThePrice));
      } else {
        emit(AddRemoveItemValidState());
      }
    });

    on<AddRemoveItemSubmittedEvent>((event, emit) async {
      emit(AddRemoveItemLoadingState());
      ApiResponse<AddQuoteItemModel> response;

      if (event.isFromDelete) {
        response = await appRepositoryValidation.removeQuoteItem(
          providerUniqueId: providerId,
          quoteUniqueId: event.quoteUniqueId,
          itemId: event.quoteItemId.toString(),
        );
      } else {
        response = await appRepositoryValidation.addQuoteItem(
          providerUniqueId: providerId,
          quoteUniqueId: event.quoteUniqueId,
          description: event.description.trim(),
          price: double.parse(event.itemPrice.trim()),
        );
      }

      if (response.status == ApiResponseStatus.completed) {
        AddQuoteItemModel? addQuoteItemModel = response.data;
        if (addQuoteItemModel != null) {
          emit(AddRemoveItemCompleteState(ItemDetails(
            quoteItemId: addQuoteItemModel.quoteItemId ?? 0,
            description: addQuoteItemModel.description.toString(),
            itemPrice: addQuoteItemModel.itemPrice ?? 0.00,
            taxAmount: addQuoteItemModel.taxAmount!.toStringAsFixed(2),
            totalQuotePrice:
                addQuoteItemModel.totalQuotePrice!.toStringAsFixed(2),
            isFromDelete: event.isFromDelete,
          )));
        } else {
          emit(AddRemoveItemErrorState(response.messageKey,
              bgColor: AppColors.red));
        }
      } else {
        emit(AddRemoveItemErrorState(response.messageKey,
            bgColor: AppColors.red));
      }
    });
  }
}
