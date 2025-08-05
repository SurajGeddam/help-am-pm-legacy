import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../modules/payment/model/payment_status_model.dart';
import '../../../modules/provider_new_order/model/api/new_order_list_model.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../network/api_response.dart';
import '../repositories/app_repository_validation.dart';
import '../service_locator.dart';
import 'stripe_payment_state.dart';

class StripePaymentCubit extends Cubit<StripePaymentState> {
  StripePaymentCubit() : super(StripeInitialState());

  Map<String, dynamic>? paymentIntentData;

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  Future<void> makePayment(String amount, Quotes scheduleOrder) async {
    emit(StripeLoadingState());
    try {
      Stripe.publishableKey = AppConstants.stripePublishableKey;
      var response = await appRepositoryValidation.createPaymentIntent(
          quoteUniqueId: scheduleOrder.orderNumber);

      /// get response data
      paymentIntentData = response.data;

      if (paymentIntentData != null) {
        await Stripe.instance
            .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  merchantDisplayName: AppConstants.applicationName,
                  customerId: paymentIntentData!["customerId"],
                  paymentIntentClientSecret:
                      paymentIntentData!["client_secret"],
                  customerEphemeralKeySecret:
                      paymentIntentData!["ephemeralKey"],
                  billingDetails: BillingDetails(
                      name: scheduleOrder.customerName,
                      phone: scheduleOrder.customerPhone,
                      email: scheduleOrder.customerEmail,
                      address: Address(
                          postalCode: scheduleOrder.customerAddress?.zipcode,
                          city: scheduleOrder.customerAddress?.district,
                          country: scheduleOrder.customerAddress?.country,
                          line1: scheduleOrder.customerAddress?.street,
                          line2: '',
                          state: scheduleOrder.customerAddress?.county))),
            )
            .then((value) => "I m here after created");

        displayPaymentSheet(scheduleOrder);
      }
    } catch (e, s) {
      AppUtils.debugPrint("Exception ==> $e: $s");
      emit(StripeErrorState(e.toString()));
    }
  }

  calculateAmount(String amount) {
    final a = double.parse(amount) * 100;
    return a.toInt().toString();
  }

  displayPaymentSheet(Quotes scheduleOrder) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        /// success state
        savePaymentDetails(scheduleOrder);
      });
    } on Exception catch (e) {
      if (e is StripeException) {
        AppUtils.debugPrint("Error from stripe $e");
        emit(StripeErrorState("Pay Error"));
        // AppUtils.showSnackBar("Pay Error", bgColor: AppColors.red);
      } else {
        AppUtils.debugPrint("Unforeseen error $e");
        emit(StripeErrorState("Pay Error"));
        // AppUtils.showSnackBar("Pay Error", bgColor: AppColors.red);
      }
    } catch (e) {
      AppUtils.debugPrint("Exception ==> $e");
      emit(StripeErrorState(e.toString()));
    }
  }

  savePaymentDetails(Quotes scheduleOrder) async {
    ApiResponse<PaymentStatusModel> response =
        await appRepositoryValidation.savePaymentConfirmation(
            quoteUniqueId: scheduleOrder.orderNumber,
            paymentId: paymentIntentData!["id"]);
    // AppUtils.showSnackBar("Pay successfully", bgColor: AppColors.green);
    if (response.status == ApiResponseStatus.completed) {
      emit(StripeLoadedState(response.data));
    } else {
      emit(StripeErrorState("Pay Error"));
    }
  }
}
