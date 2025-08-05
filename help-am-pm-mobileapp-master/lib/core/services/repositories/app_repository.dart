import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core_components/common_models/key_value_model.dart';
import '../../../core_components/common_models/message_status_model.dart';
import '../../../core_components/common_models/notification_model.dart';
import '../../../modules/address/model/save_address_model/request_body/save_address_req_body_model.dart';
import '../../../modules/contact_us/model/contact_us_model.dart';
import '../../../modules/customer_booking/model/new_booking_req_body_model.dart';
import '../../../modules/help/model/faq_model.dart';
import '../../../modules/login/model/login_model/auth_token_model.dart';
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
import '../model/country_code_model.dart';
import '../model/upload_file_response_model.dart';
import '../network/api_response.dart';
import 'app_services.dart';

class AppRepository {
  final AppServices appServices;

  AppRepository(this.appServices);

  /// notification setting
  Future<ApiResponse<MessageStatusModel>> notificationSetting(
    String type,
    bool enabled,
  ) async {
    try {
      final response = await appServices.notificationSetting(type, enabled);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Get All Country Code
  Future<ApiResponse<List<CountryCodeModel>>> getAllCountryCode() async {
    try {
      final response = await appServices.getAllCountryCode();
      final list = (response.data as List)
          .map((e) => CountryCodeModel.fromJson(e))
          .toList();
      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Delete account
  Future<ApiResponse<MessageStatusModel>> deleteAccount(
    String username,
  ) async {
    try {
      final response = await appServices.deleteAccount(username);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Logout
  Future<ApiResponse<MessageStatusModel>> logout(
    String deviceId,
    String username,
  ) async {
    try {
      final response = await appServices.logout(deviceId, username);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Cancel Quote
  Future<ApiResponse<MessageStatusModel>> cancelQuote(
      String quoteUniqueId) async {
    try {
      final response = await appServices.cancelQuote(quoteUniqueId);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Save Payment details
  Future<ApiResponse<List<NotificationModel>>> getNotifications(
      String username) async {
    try {
      final response = await appServices.getNotifications(username);
      final list = (response.data as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Payment details
  Future<ApiResponse<PaymentStatusModel>> savePaymentDetails(
      String quoteUniqueId, String paymentId) async {
    try {
      final response =
          await appServices.savePaymentDetails(quoteUniqueId, paymentId);
      return ApiResponse.completed(PaymentStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Create Payment details
  Future<ApiResponse> createPaymentIntent(String quoteUniqueId) async {
    try {
      final response = await appServices.createPaymentIntent(quoteUniqueId);
      final parsedJson = jsonDecode(response.data);
      return ApiResponse.completed(parsedJson);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Quote details
  Future<ApiResponse<Quotes>> quoteDetails(String quoteUniqueId) async {
    try {
      final response = await appServices.quoteDetails(quoteUniqueId);
      return ApiResponse.completed(Quotes.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Remove Quote Item
  Future<ApiResponse<AddQuoteItemModel>> removeQuoteItem(
    String quoteUniqueId,
    String providerUniqueId,
    String itemId,
  ) async {
    try {
      final response = await appServices.removeQuoteItem(
          quoteUniqueId, providerUniqueId, itemId);
      return ApiResponse.completed(AddQuoteItemModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Add Quote Item
  Future<ApiResponse<AddQuoteItemModel>> addQuoteItem(
    String quoteUniqueId,
    String providerUniqueId,
    String description,
    double price,
  ) async {
    try {
      final response = await appServices.addQuoteItem(
          quoteUniqueId, providerUniqueId, description, price);
      return ApiResponse.completed(AddQuoteItemModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Update FCM Device Token
  Future<ApiResponse<MessageStatusModel>> updateFCMDeviceToken(
    String deviceId,
    String username,
    String deviceType,
  ) async {
    try {
      final response = await appServices.updateFCMDeviceToken(
          deviceId, username, deviceType);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Ongoing Order
  Future<ApiResponse<List<Quotes>>> getCustomerOngoingOrder(
    String id,
  ) async {
    try {
      final response = await appServices.getCustomerOngoingOrder(id);
      final list =
          (response.data as List).map((e) => Quotes.fromJson(e)).toList();
      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Ongoing Order
  Future<ApiResponse<List<Quotes>>> getProviderOngoingOrder(
    String id,
  ) async {
    try {
      final response = await appServices.getProviderOngoingOrder(id);
      final quotesResponse = (response.data as Map)['quotes'];

      final list =
          (quotesResponse as List).map((e) => Quotes.fromJson(e)).toList();

      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// download invoice
  Future<ApiResponse<String>> downloadInvoice(String id) async {
    try {
      final response = await appServices.downloadInvoice(id);
      return ApiResponse.completed(response.data);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  ///  Order End
  Future<ApiResponse<MessageStatusModel>> submitFeedback(
      String givenTo,
      int rating,
      String feedback,
      String givenBy,
      KeyValueModel? selectedComment) async {
    try {
      final response = await appServices.submitFeedback(
          givenTo, rating, feedback, givenBy, selectedComment);

      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  ///  Order End
  Future<ApiResponse<MessageStatusModel>> orderEnd(
    String providerUniqueId,
    String quoteUniqueId,
  ) async {
    try {
      final response =
          await appServices.orderEnd(providerUniqueId, quoteUniqueId);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  ///  Order Start
  Future<ApiResponse<MessageStatusModel>> orderStart(
    String providerUniqueId,
    String quoteUniqueId,
  ) async {
    try {
      final response =
          await appServices.orderStart(providerUniqueId, quoteUniqueId);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Order confirm
  Future<ApiResponse<MessageStatusModel>> orderConfirm(
    String quoteUniqueId,
    String providerUniqueId,
    String selectedDelay,
  ) async {
    try {
      final response = await appServices.orderConfirm(
          quoteUniqueId, providerUniqueId, selectedDelay);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Get search provider list
  Future<ApiResponse<List<SearchProviderModel>>> getSearchProvider(
      SearchProviderReqBodyModel obj) async {
    try {
      final response = await appServices.getSearchProvider(obj);
      final list = (response.data as List)
          .map((e) => SearchProviderModel.fromJson(e))
          .toList();
      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Customer Order History
  Future<ApiResponse<List<Quotes>>> getCustomerOrderHistory(
    String id,
  ) async {
    try {
      final response = await appServices.getCustomerOrderHistory(id);
      final list =
          (response.data as List).map((e) => Quotes.fromJson(e)).toList();
      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Provider Order History
  Future<ApiResponse<List<Quotes>>> getProviderOrderHistory(
    String id,
  ) async {
    try {
      final response = await appServices.getProviderOrderHistory(id);
      final quotesResponse = (response.data as Map)['quotes'];

      final list =
          (quotesResponse as List).map((e) => Quotes.fromJson(e)).toList();

      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// faq details
  Future<ApiResponse<List<FaqModel>>> getFaqData() async {
    try {
      final response = await appServices.getFaqResponse();
      final list =
          (response.data as List).map((e) => FaqModel.fromJson(e)).toList();
      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// contact us details
  Future<ApiResponse<List<ContactUsModel>>> getContactUsData() async {
    try {
      final response = await appServices.getContactUsResponse();
      final list = (response.data as List)
          .map((e) => ContactUsModel.fromJson(e))
          .toList();
      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Provider Profile
  Future<ApiResponse<ProfileModel>> getProviderProfile(
    String providerUniqueId,
  ) async {
    try {
      final response = await appServices.getProviderProfile(providerUniqueId);

      final providerProfileModelResponse = ProfileModel.fromJson(response.data);

      return ApiResponse.completed(providerProfileModelResponse);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Provider Profile
  Future<ApiResponse<ProfileModel>> getCustomerProfile(
    String customerUniqueId,
  ) async {
    try {
      final response = await appServices.getCustomerProfile(customerUniqueId);
      final profileModelResponse = ProfileModel.fromJson(response.data);
      return ApiResponse.completed(profileModelResponse);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  Future<ApiResponse<MessageStatusModel>> updateProviderProfile(
    String providerUniqueId,
    ProfileModel profileModel,
  ) async {
    try {
      final response = await appServices.updateProviderProfile(
          providerUniqueId, profileModel);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  Future<ApiResponse<MessageStatusModel>> updateCustomerProfile(
    String customerUniqueId,
    ProfileModel profileModel,
  ) async {
    try {
      final response = await appServices.updateCustomerProfile(
          customerUniqueId, profileModel);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// New Order
  Future<ApiResponse<NewOrderListModel>> getNewOrder(
    String id,
  ) async {
    try {
      final response = await appServices.getNewOrder(id);

      return ApiResponse.completed(NewOrderListModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// New Booking Request
  Future<ApiResponse<MessageStatusModel>> newBookingRequest(
      NewBookingReqBodyModel obj) async {
    try {
      final response = await appServices.newBookingRequest(obj);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Update Address
  Future<ApiResponse<MessageStatusModel>> updateAddress(
    String id,
    SaveAddressReqBodyModel reqBody,
  ) async {
    try {
      final response = await appServices.updateAddress(id, reqBody);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Save Address
  Future<ApiResponse<MessageStatusModel>> saveAddress(
    String id,
    SaveAddressReqBodyModel reqBody,
  ) async {
    try {
      final response = await appServices.saveAddress(id, reqBody);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Get Address
  Future<ApiResponse<List<SaveAddressReqBodyModel>>> getAddress(
    String id,
  ) async {
    try {
      final response = await appServices.getAddress(id);
      final list = (response.data as List)
          .map((e) => SaveAddressReqBodyModel.fromJson(e))
          .toList();
      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Upload file
  Future<ApiResponse<UploadFileResponseModel>> uploadFile(
    File file,
    UploadFileModel uploadFile,
  ) async {
    try {
      final response = await appServices.uploadFile(file, uploadFile);
      return ApiResponse.completed(
          UploadFileResponseModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
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
    try {
      final response = await appServices.providerLocation(
          providerUniqueId, latitude, longitude, altitude, landmark, createdAt);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Customer SignUp
  Future<ApiResponse<MessageStatusModel>> addNewCustomer({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String emailId,
    required String password,
    required bool isActive,
  }) async {
    try {
      final response = await appServices.addNewCustomer(
        firstName,
        lastName,
        phoneNumber,
        emailId,
        password,
        isActive,
      );
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Schedule Order for Customer
  Future<ApiResponse<List<Quotes>>> getCustomerScheduleOrders(
    String id,
  ) async {
    try {
      final response = await appServices.getCustomerScheduleOrders(id);
      final list =
          (response.data as List).map((e) => Quotes.fromJson(e)).toList();
      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Schedule Order for Provider
  Future<ApiResponse<List<Quotes>>> getScheduleOrders(
    String id,
  ) async {
    try {
      final response = await appServices.getScheduleOrders(id);
      final quotesResponse = (response.data as Map)['quotes'];
      final list =
          (quotesResponse as List).map((e) => Quotes.fromJson(e)).toList();
      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Provider Log
  Future<ApiResponse<ProviderLogModel>> getProviderLog(
    String id,
  ) async {
    try {
      final response = await appServices.getProviderLog(id);
      return ApiResponse.completed(ProviderLogModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Insurance Type
  Future<ApiResponse<List<PolicyTypeModel>>> getInsuranceType() async {
    try {
      final response = await appServices.getInsuranceType();
      final list = (response.data as List)
          .map((e) => PolicyTypeModel.fromJson(e))
          .toList();
      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// License Type
  Future<ApiResponse<List<PolicyTypeModel>>> getLicenseType() async {
    try {
      final response = await appServices.getLicenseType();
      final list = (response.data as List)
          .map((e) => PolicyTypeModel.fromJson(e))
          .toList();
      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Save Bank
  Future<ApiResponse<MessageStatusModel>> saveBank(
    SaveBankReqBodyModel obj,
    String id,
  ) async {
    try {
      final response = await appServices.saveBank(obj, id);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Save Vehicle
  Future<ApiResponse<MessageStatusModel>> saveVehicle(
    SaveVehicleReqBodyModel obj,
    String id,
  ) async {
    try {
      final response = await appServices.saveVehicle(obj, id);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Save License
  Future<ApiResponse<MessageStatusModel>> saveLicense(
    SaveLicenseReqBodyModel obj,
    String id,
  ) async {
    try {
      final response = await appServices.saveLicense(obj, id);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Save Insurance
  Future<ApiResponse<MessageStatusModel>> saveInsurance(
    SaveInsuranceReqBodyModel obj,
    String id,
  ) async {
    try {
      final response = await appServices.saveInsurance(obj, id);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Save Individual
  Future<ApiResponse<MessageStatusModel>> saveIndividual(
    SaveCompanyDetailReqBodyModel obj,
    String id,
  ) async {
    try {
      final response = await appServices.saveIndividual(obj, id);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Saved category
  Future<ApiResponse<MessageStatusModel>> saveSelectedCategory(
    CategoryModel obj,
    String id,
  ) async {
    try {
      final response = await appServices.saveSelectedCategory(obj, id);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// All category list
  Future<ApiResponse<List<CategoryModel>>> getCategory() async {
    try {
      final response = await appServices.getCategory();
      final list = (response.data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
      return ApiResponse.completed(list);
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Refresh Token
  Future<ApiResponse<AuthTokenModel>> refreshToken({
    required String token,
    required String expiryDate,
    required String username,
  }) async {
    try {
      final response = await appServices.refreshToken(
        token,
        expiryDate,
        username,
      );
      return ApiResponse.completed(AuthTokenModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// Login
  Future<ApiResponse<AuthTokenModel>> authToken({
    required String userName,
    required String password,
  }) async {
    try {
      final response = await appServices.authToken(userName, password);
      return ApiResponse.completed(AuthTokenModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  Future<ApiResponse<MessageStatusModel>> forgotPasswordSendOtp({
    required String userName,
  }) async {
    try {
      final response = await appServices.forgotPasswordSendOtp(userName);
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// reset password
  Future<ApiResponse<MessageStatusModel>> resetPassword({
    required String userId,
    required String password,
    required String otp,
  }) async {
    try {
      final response = await appServices.resetPassword(
        userId,
        password,
        otp,
      );
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// change password
  Future<ApiResponse<MessageStatusModel>> changePassword({
    required String userId,
    required String oldPassword,
    required String password,
  }) async {
    try {
      final response = await appServices.changePassword(
        userId,
        oldPassword,
        password,
      );
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }

  /// SignUp
  Future<ApiResponse<MessageStatusModel>> addNewProvider({
    required String emailId,
    required String password,
    bool isIndividual = false,
  }) async {
    try {
      final response = await appServices.addNewProvider(
        emailId,
        password,
        isIndividual,
      );
      return ApiResponse.completed(MessageStatusModel.fromJson(response.data));
    } on DioError catch (e) {
      return ApiResponse.error(e);
    }
  }
}
