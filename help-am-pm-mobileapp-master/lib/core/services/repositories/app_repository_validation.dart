import 'dart:io';

import 'package:dio/dio.dart';
import 'package:helpampm/utils/app_utils.dart';

import '../../../core_components/common_models/key_value_model.dart';
import '../../../core_components/common_models/message_status_model.dart';
import '../../../core_components/common_models/notification_model.dart';
import '../../../modules/address/model/save_address_model/request_body/save_address_req_body_model.dart';
import '../../../modules/contact_us/model/contact_us_model.dart';
import '../../../modules/customer_booking/model/new_booking_req_body_model.dart';
import '../../../modules/help/model/faq_model.dart';
import '../../../modules/onboarding/model/bank_model/save_bank_req_body_model.dart';
import '../../../modules/onboarding/model/category_model/api/category_model.dart';
import '../../../modules/onboarding/model/common/policy_type_model.dart';
import '../../../modules/onboarding/model/company_details_model/save_company_detail_req_body_model.dart';
import '../../../modules/onboarding/model/insurance_model/save_insurance_req_body_model.dart';
import '../../../modules/onboarding/model/license_model/save_license_req_boy_model.dart';
import '../../../modules/onboarding/model/vehicle_model/save_vehicle_req_body_model.dart';
import '../../../modules/payment/model/payment_status_model.dart';
import '../../../modules/profile/model/provider_profile_model.dart';
import '../../../modules/provider_home/model/provider_log_model/provider_log_model.dart';
import '../../../modules/provider_new_order/model/api/new_order_list_model.dart';
import '../../../modules/provider_orders/model/add_quote_item_model.dart';
import '../../../modules/searching_provider/model/search_provider_req_body_model.dart';
import '../../../modules/searching_provider/model/search_provider_response_model.dart';
import '../media/uoload_file_model.dart';
import '../model/upload_file_response_model.dart';
import '../network/api_response.dart';
import 'app_repository.dart';

class AppRepositoryValidation {
  final AppRepository appRepository;

  AppRepositoryValidation(this.appRepository);

  DioError dioError = DioError(
    type: DioErrorType.response,
    requestOptions: RequestOptions(path: ''),
    response: Response(
      statusCode: 403,
      requestOptions: RequestOptions(path: ''),
    ),
  );

  Future<ApiResponse<MessageStatusModel>> notificationSetting({
    required String type,
    required bool enabled,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.notificationSetting(type, enabled);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Delete account
  Future<ApiResponse<MessageStatusModel>> deleteAccount({
    required String username,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.deleteAccount(username);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Logout
  Future<ApiResponse<MessageStatusModel>> logout({
    required String deviceId,
    required username,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.logout(deviceId, username);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// create Payment Intent
  Future<ApiResponse<MessageStatusModel>> cancelQuote({
    required String quoteUniqueId,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.cancelQuote(quoteUniqueId);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// create Payment Intent
  Future<ApiResponse<List<NotificationModel>>> getNotifications(
      {required String username}) async {
    if (await isAuthorized()) {
      ApiResponse<List<NotificationModel>> response =
          await appRepository.getNotifications(username);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// create Payment Intent
  Future<ApiResponse<PaymentStatusModel>> savePaymentConfirmation(
      {required String quoteUniqueId, required String paymentId}) async {
    if (await isAuthorized()) {
      ApiResponse<PaymentStatusModel> response =
          await appRepository.savePaymentDetails(quoteUniqueId, paymentId);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// create Payment Intent
  Future<ApiResponse> createPaymentIntent({
    required String quoteUniqueId,
  }) async {
    if (await isAuthorized()) {
      ApiResponse response =
          await appRepository.createPaymentIntent(quoteUniqueId);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Quote Details
  Future<ApiResponse<Quotes>> quoteDetails({
    required String quoteUniqueId,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<Quotes> response =
          await appRepository.quoteDetails(quoteUniqueId);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Update FCM Device Token
  Future<ApiResponse<MessageStatusModel>> updateFCMDeviceToken({
    required String deviceId,
    required username,
    required deviceType,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response = await appRepository
          .updateFCMDeviceToken(deviceId, username, deviceType);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Remove Quote Item
  Future<ApiResponse<AddQuoteItemModel>> removeQuoteItem({
    required String quoteUniqueId,
    required String providerUniqueId,
    required String itemId,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<AddQuoteItemModel> response = await appRepository
          .removeQuoteItem(quoteUniqueId, providerUniqueId, itemId);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Add Quote Item
  Future<ApiResponse<AddQuoteItemModel>> addQuoteItem({
    required String quoteUniqueId,
    required String providerUniqueId,
    required String description,
    required double price,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<AddQuoteItemModel> response = await appRepository
          .addQuoteItem(quoteUniqueId, providerUniqueId, description, price);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Ongoing order
  Future<ApiResponse<List<Quotes>>> getCustomerOngoingOrder({
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<List<Quotes>> response =
          await appRepository.getCustomerOngoingOrder(id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Ongoing order
  Future<ApiResponse<List<Quotes>>> getProviderOngoingOrder({
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<List<Quotes>> response =
          await appRepository.getProviderOngoingOrder(id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// download invoice
  Future<ApiResponse<String>> downloadInvoice({required String id}) async {
    if (await isAuthorized()) {
      ApiResponse<String> response = await appRepository.downloadInvoice(id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// feedback
  Future<ApiResponse<MessageStatusModel>> submitFeedback({
    required String givenTo,
    required int rating,
    required String feedback,
    required String givenBy,
    KeyValueModel? selectedComment,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response = await appRepository
          .submitFeedback(givenTo, rating, feedback, givenBy, selectedComment);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Order End
  Future<ApiResponse<MessageStatusModel>> orderEnd({
    required String providerUniqueId,
    required String quoteUniqueId,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.orderEnd(providerUniqueId, quoteUniqueId);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Order Start
  Future<ApiResponse<MessageStatusModel>> orderStart({
    required String providerUniqueId,
    required String quoteUniqueId,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.orderStart(providerUniqueId, quoteUniqueId);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Confirm Order
  Future<ApiResponse<MessageStatusModel>> orderConfirm({
    required String quoteUniqueId,
    required String providerUniqueId,
    required String selectedDelay,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response = await appRepository
          .orderConfirm(quoteUniqueId, providerUniqueId, selectedDelay);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Get search provider list
  Future<ApiResponse<List<SearchProviderModel>>> getSearchProvider({
    required SearchProviderReqBodyModel obj,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<List<SearchProviderModel>> response =
          await appRepository.getSearchProvider(obj);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Customer order history
  Future<ApiResponse<List<Quotes>>> getCustomerOrderHistory({
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<List<Quotes>> response =
          await appRepository.getCustomerOrderHistory(id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Provider Order History
  Future<ApiResponse<List<Quotes>>> getProviderOrderHistory({
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<List<Quotes>> response =
          await appRepository.getProviderOrderHistory(id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  Future<ApiResponse<List<FaqModel>>> getFaqResponse() async {
    if (await isAuthorized()) {
      ApiResponse<List<FaqModel>> response = await appRepository.getFaqData();
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  Future<ApiResponse<List<ContactUsModel>>> getContactUsResponse() async {
    if (await isAuthorized()) {
      ApiResponse<List<ContactUsModel>> response =
          await appRepository.getContactUsData();
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  Future<ApiResponse<ProfileModel>> getProviderProfile({
    required String providerUniqueId,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<ProfileModel> response =
          await appRepository.getProviderProfile(providerUniqueId);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  Future<ApiResponse<ProfileModel>> getCustomerProfile({
    required String customerUniqueId,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<ProfileModel> response =
          await appRepository.getCustomerProfile(customerUniqueId);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  Future<ApiResponse<MessageStatusModel>> updateProviderProfile({
    required String providerUniqueId,
    required ProfileModel profileModel,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response = await appRepository
          .updateProviderProfile(providerUniqueId, profileModel);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  Future<ApiResponse<MessageStatusModel>> updateCustomerProfile({
    required String customerUniqueId,
    required ProfileModel profileModel,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response = await appRepository
          .updateCustomerProfile(customerUniqueId, profileModel);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  Future<ApiResponse<MessageStatusModel>> changePassword({
    required String userId,
    required String oldPassword,
    required String password,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.changePassword(
              userId: userId, oldPassword: oldPassword, password: password);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// New Order
  Future<ApiResponse<NewOrderListModel>> getNewOrder({
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<NewOrderListModel> response =
          await appRepository.getNewOrder(id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Save Address
  Future<ApiResponse<MessageStatusModel>> newBookingRequest(
      {required NewBookingReqBodyModel reqBody}) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.newBookingRequest(reqBody);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Update Address
  Future<ApiResponse<MessageStatusModel>> updateAddress({
    required String id,
    required SaveAddressReqBodyModel reqBody,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.updateAddress(id, reqBody);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Save Address
  Future<ApiResponse<MessageStatusModel>> saveAddress({
    required String id,
    required SaveAddressReqBodyModel reqBody,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.saveAddress(id, reqBody);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Get Address
  Future<ApiResponse<List<SaveAddressReqBodyModel>>> getAddress({
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<List<SaveAddressReqBodyModel>> response =
          await appRepository.getAddress(id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Upload file
  Future<ApiResponse<UploadFileResponseModel>> uploadFile({
    required File file,
    required UploadFileModel uploadFile,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<UploadFileResponseModel> response =
          await appRepository.uploadFile(file, uploadFile);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Provider Location
  Future<ApiResponse<MessageStatusModel>> providerLocation({
    required String providerUniqueId,
    required double latitude,
    required double longitude,
    required double altitude,
    required String landmark,
    required String createdAt,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.providerLocation(
        providerUniqueId: providerUniqueId,
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
        landmark: landmark,
        createdAt: createdAt,
      );
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Schedule Order for Customer
  Future<ApiResponse<List<Quotes>>> getCustomerScheduleOrders({
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<List<Quotes>> response =
          await appRepository.getCustomerScheduleOrders(id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Schedule Order for Provider
  Future<ApiResponse<List<Quotes>>> getScheduleOrders({
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<List<Quotes>> response =
          await appRepository.getScheduleOrders(id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Provider Log
  Future<ApiResponse<ProviderLogModel>> getProviderLog({
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<ProviderLogModel> response =
          await appRepository.getProviderLog(id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Insurance Type
  Future<ApiResponse<List<PolicyTypeModel>>> getInsuranceType() async {
    if (await isAuthorized()) {
      ApiResponse<List<PolicyTypeModel>> response =
          await appRepository.getInsuranceType();
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// License Type
  Future<ApiResponse<List<PolicyTypeModel>>> getLicenseType() async {
    if (await isAuthorized()) {
      ApiResponse<List<PolicyTypeModel>> response =
          await appRepository.getLicenseType();
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Save Bank
  Future<ApiResponse<MessageStatusModel>> saveBank({
    required SaveBankReqBodyModel obj,
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.saveBank(obj, id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Save Vehicle
  Future<ApiResponse<MessageStatusModel>> saveVehicle({
    required SaveVehicleReqBodyModel obj,
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.saveVehicle(obj, id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Save License
  Future<ApiResponse<MessageStatusModel>> saveLicense({
    required SaveLicenseReqBodyModel obj,
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.saveLicense(obj, id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Save Insurance
  Future<ApiResponse<MessageStatusModel>> saveInsurance({
    required SaveInsuranceReqBodyModel obj,
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.saveInsurance(obj, id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Save Individual
  Future<ApiResponse<MessageStatusModel>> saveIndividual({
    required SaveCompanyDetailReqBodyModel obj,
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.saveIndividual(obj, id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  /// Saved category
  Future<ApiResponse<MessageStatusModel>> saveSelectedCategory({
    required CategoryModel obj,
    required String id,
  }) async {
    if (await isAuthorized()) {
      ApiResponse<MessageStatusModel> response =
          await appRepository.saveSelectedCategory(obj, id);
      return response;
    } else {
      return ApiResponse.error(dioError);
    }
  }

  Future<bool> isAuthorized() async {
    if (AppUtils.accessTokenIsValid()) {
      return true;
    } else {
      if (await AppUtils.refreshTokenIsValid()) {
        AppUtils.getNewAccessToken();
        return true;
      } else {
        return false;
      }
    }
  }
}
