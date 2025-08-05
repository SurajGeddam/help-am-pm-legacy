import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:helpampm/modules/profile/model/provider_profile_model.dart';

import '../../../core_components/common_models/key_value_model.dart';
import '../../../modules/address/model/save_address_model/request_body/save_address_req_body_model.dart';
import '../../../modules/customer_booking/model/new_booking_req_body_model.dart';
import '../../../modules/onboarding/model/bank_model/save_bank_req_body_model.dart';
import '../../../modules/onboarding/model/category_model/api/category_model.dart';
import '../../../modules/onboarding/model/company_details_model/save_company_detail_req_body_model.dart';
import '../../../modules/onboarding/model/insurance_model/save_insurance_req_body_model.dart';
import '../../../modules/onboarding/model/license_model/save_license_req_boy_model.dart';
import '../../../modules/onboarding/model/vehicle_model/save_vehicle_req_body_model.dart';
import '../../../modules/searching_provider/model/search_provider_req_body_model.dart';
import '../../../utils/app_utils.dart';
import '../bloc/previous_location.dart';
import '../media/uoload_file_model.dart';
import '../network/dio_client.dart';
import '../network/endpoints.dart';

class AppServices {
  final DioClient dioClient;

  AppServices({required this.dioClient});

  Future<Response> notificationSetting(
    String type,
    bool enabled,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/settings/notification",
        data: {
          "type": type,
          "enabled": enabled,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllCountryCode() async {
    try {
      final Response response =
          await dioClient.get("${Endpoints.baseUrl}/country/public");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteAccount(
    String username,
  ) async {
    try {
      final Response response =
          await dioClient.get("${Endpoints.baseUrl}/auth/delete/$username");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> logout(
    String deviceId,
    String username,
  ) async {
    try {
      final Response response = await dioClient.delete(
          "${Endpoints.baseUrl}/auth/logout/$username?deviceId=$deviceId");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getNotifications(String username) async {
    try {
      final Response response = await dioClient
          .get("${Endpoints.baseUrl}/notification/user/$username");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> cancelQuote(String quoteUniqueId) async {
    try {
      final Response response = await dioClient
          .put("${Endpoints.baseUrl}/quote/$quoteUniqueId/cancel");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> savePaymentDetails(
      String quoteUniqueId, String paymentId) async {
    try {
      final Response response = await dioClient
          .put("${Endpoints.baseUrl}/payment/add/$quoteUniqueId/$paymentId");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createPaymentIntent(String quoteUniqueId) async {
    try {
      final Response response = await dioClient
          .get("${Endpoints.baseUrl}/payment/create-intent/$quoteUniqueId");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateFCMDeviceToken(
    String deviceId,
    String username,
    String deviceType,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/pushnotification",
        data: {
          "deviceId": deviceId,
          "username": username,
          "deviceType": deviceType,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> quoteDetails(
    String quoteUniqueId,
  ) async {
    try {
      final Response response =
          await dioClient.get("${Endpoints.baseUrl}/quote/$quoteUniqueId");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> removeQuoteItem(
    String quoteUniqueId,
    String providerUniqueId,
    String itemId,
  ) async {
    try {
      final Response response = await dioClient.put(
          "${Endpoints.baseUrl}/quote/$quoteUniqueId/$providerUniqueId/$itemId/remove-quote-item");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addQuoteItem(
    String quoteUniqueId,
    String providerUniqueId,
    String description,
    double price,
  ) async {
    try {
      final Response response = await dioClient.put(
        "${Endpoints.baseUrl}/quote/$quoteUniqueId/$providerUniqueId/add-quote-item",
        data: {
          "description": description,
          "price": price,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCustomerOngoingOrder(
    String id,
  ) async {
    try {
      final Response response = await dioClient
          .get("${Endpoints.baseUrl}/quote/customer/$id/started");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getProviderOngoingOrder(
    String id,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/quote/mobile/pageable-orders/started",
        data: {
          "orderColumn": "createdAt",
          "orderDir": "DESC",
          "pageNumber": 0,
          "pageSize": 50,
          "providerUniqueId": id,
          "searchText": ""
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> downloadInvoice(String quoteUniqueId) async {
    try {
      var response = await dioClient
          .get("${Endpoints.baseUrl}/invoice/generateinvoice/$quoteUniqueId");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> submitFeedback(
    String givenTo,
    int rating,
    String feedback,
    String givenBy,
    KeyValueModel? selectedComment,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/review",
        data: {
          "givenToId": givenTo,
          "givenById": givenBy,
          "rating": rating,
          "tags": [
            {
              "id": selectedComment?.key ?? "0",
              "tag": selectedComment?.value ?? "",
            }
          ],
          "comment": feedback
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> orderEnd(
    String providerUniqueId,
    String quoteUniqueId,
  ) async {
    try {
      final Response response = await dioClient.put(
          "${Endpoints.baseUrl}/quote/$quoteUniqueId/$providerUniqueId/complete");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> orderStart(
      String providerUniqueId, String quoteUniqueId) async {
    try {
      final Response response = await dioClient.put(
        "${Endpoints.baseUrl}/quote/$quoteUniqueId/$providerUniqueId/start-work",
        data: {
          "latitude": PreviousLocation.instance.previousLatitude,
          "longitude": PreviousLocation.instance.previousLongitude,
          "altitude": 0,
          "workStartTime": AppUtils.getDateDDMMYYYYhhmmss(DateTime.now())
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> orderConfirm(
    String quoteUniqueId,
    String providerUniqueId,
    String selectedDelay,
  ) async {
    try {
      final Response response = await dioClient.put(
          "${Endpoints.baseUrl}/quote/$quoteUniqueId/$providerUniqueId/$selectedDelay/confirm");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getSearchProvider(
    SearchProviderReqBodyModel obj,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/provider/mobile/search",
        data: {
          "category": obj.category,
          "isResidential": obj.isResidential,
          "isCommercial": obj.isCommercial,
          "latitude": obj.latitude,
          "longitude": obj.longitude,
          "altitude": obj.altitude,
          "radius": obj.radius,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCustomerOrderHistory(
    String customerId,
  ) async {
    try {
      final Response response = await dioClient
          .get("${Endpoints.baseUrl}/quote/customer/$customerId/history");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getProviderOrderHistory(
    String providerUniqueId,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/quote/mobile/pageable-orders/history",
        data: {
          "orderColumn": "createdAt",
          "orderDir": "DESC",
          "pageNumber": 0,
          "pageSize": 50,
          "providerUniqueId": providerUniqueId,
          "searchText": ""
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getFaqResponse() async {
    try {
      final Response response =
          await dioClient.get("${Endpoints.baseUrl}/help/faq/all");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getContactUsResponse() async {
    try {
      final Response response =
          await dioClient.get("${Endpoints.baseUrl}/help/support_info/all");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getProviderProfile(
    String providerUniqueId,
  ) async {
    try {
      final Response response = await dioClient
          .get("${Endpoints.baseUrl}/provider/profile/$providerUniqueId");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCustomerProfile(
    String customerUniqueId,
  ) async {
    try {
      final Response response = await dioClient
          .get("${Endpoints.baseUrl}/customer/profile/$customerUniqueId");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateProviderProfile(
      String providerUniqueId, ProfileModel profileModel) async {
    try {
      final Response response =
          await dioClient.put("${Endpoints.baseUrl}/provider/profile", data: {
        "providerUniqueId": providerUniqueId,
        "profilePicture": profileModel.profilePicture,
        "name": profileModel.name,
        "mobileNumber": profileModel.mobileNumber,
        "dateOfBirth": profileModel.dateOfBirth
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateCustomerProfile(
      String customerUniqueId, ProfileModel profileModel) async {
    try {
      final Response response =
          await dioClient.put("${Endpoints.baseUrl}/customer/profile", data: {
        "customerUniqueId": customerUniqueId,
        "profilePicture": profileModel.profilePicture,
        "firstName": profileModel.firstName,
        "lastName": profileModel.lastName,
        "mobileNumber": profileModel.mobileNumber,
        "dateOfBirth": profileModel.dateOfBirth
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getNewOrder(
    String id,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/quote/mobile/pageable-orders/neworder",
        data: {
          "orderColumn": "createdAt",
          "orderDir": "DESC",
          "pageNumber": 0,
          "pageSize": 50,
          "providerUniqueId": id,
          "searchText": ""
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> newBookingRequest(NewBookingReqBodyModel obj) async {
    try {
      final response = await dioClient.post(
        "${Endpoints.baseUrl}/quote",
        data: {
          "categoryName": obj.categoryName,
          "residentialService": obj.residentialService,
          "commercialService": obj.commercialService,
          "address": {
            "building": obj.address.building,
            "street": obj.address.street,
            "district": obj.address.district,
            "county": obj.address.county,
            "country": obj.address.country,
            "zipcode": obj.address.zipcode,
            "latitude": obj.address.latitude,
            "longitude": obj.address.longitude,
            "altitude": obj.address.altitude,
            "customerUniqueId": obj.address.customerUniqueId,
          },
          "timeslot": {"id": obj.timeslots?.id},
          "serviceDate": obj.serviceDate,
          "serviceDescription": obj.serviceDescription,
          "imagePath": obj.imagePath,
          "isScheduled": obj.isScheduled,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateAddress(
    String id,
    SaveAddressReqBodyModel obj,
  ) async {
    try {
      final Response response = await dioClient.put(
        "${Endpoints.baseUrl}/customer/$id/address",
        data: {
          "building": obj.building,
          "street": obj.street,
          "district": obj.street,
          "county": obj.county,
          "country": obj.country,
          "zipcode": obj.zipcode,
          "latitude": obj.latitude,
          "longitude": obj.longitude,
          "altitude": obj.altitude,
          "customerUniqueId": id,
          "name": obj.name,
          "addressType": obj.addressType,
          "default": obj.isDefault,
          "id": obj.id,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> saveAddress(
    String id,
    SaveAddressReqBodyModel obj,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/customer/$id/address",
        data: {
          "building": obj.building,
          "street": obj.street,
          "district": obj.street,
          "county": obj.county,
          "country": obj.country,
          "zipcode": obj.zipcode,
          "latitude": obj.latitude,
          "longitude": obj.longitude,
          "altitude": obj.altitude,
          "customerUniqueId": id,
          "name": obj.name,
          "addressType": obj.addressType,
          "default": obj.isDefault,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAddress(String id) async {
    try {
      final Response response = await dioClient.get(
        "${Endpoints.baseUrl}/customer/$id/address",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> uploadFile(
    File file,
    UploadFileModel uploadFile,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path),
        "fileUploadModel": jsonEncode({
          "fileName": uploadFile.fileName,
          "purpose": uploadFile.purpose,
          "replace": uploadFile.replace,
        })
      });

      final Response response =
          await dioClient.post("${Endpoints.baseUrl}/files", data: formData);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> providerLocation(
    String providerUniqueId,
    double latitude,
    double longitude,
    double altitude,
    String landmark,
    String createdAt,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/location/provider",
        data: {
          "providerUniqueId": providerUniqueId,
          "latitude": latitude,
          "longitude": longitude,
          "altitude": altitude,
          "landmark": landmark,
          "createdAt": createdAt,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addNewCustomer(
    String firstName,
    String lastName,
    String phoneNumber,
    String emailId,
    String password,
    bool isActive,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/customer/signup",
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "phone": phoneNumber,
          "email": emailId,
          "userLoginDetails": {
            "username": emailId,
            "password": password,
          },
          "isActive": isActive,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Schedule Order for Customer
  Future<Response> getCustomerScheduleOrders(
    String id,
  ) async {
    try {
      final Response response = await dioClient
          .get("${Endpoints.baseUrl}/quote/customer/$id/scheduled");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Schedule Order for Provider
  Future<Response> getScheduleOrders(
    String id,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/quote/mobile/pageable-orders/scheduled",
        data: {
          "orderColumn": "createdAt",
          "orderDir": "DESC",
          "pageNumber": 0,
          "pageSize": 50,
          "providerUniqueId": id,
          "searchText": ""
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getProviderLog(
    String id,
  ) async {
    try {
      final Response response = await dioClient.get(
        "${Endpoints.baseUrl}/dashboard/provider/mobile/$id",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getLicenseType() async {
    try {
      final Response response = await dioClient.get(
        "${Endpoints.baseUrl}/license-type",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getInsuranceType() async {
    try {
      final Response response = await dioClient.get(
        "${Endpoints.baseUrl}/insurance-type",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> saveBank(
    SaveBankReqBodyModel obj,
    String id,
  ) async {
    try {
      final response = await dioClient.post(
        "${Endpoints.baseUrl}/provider/$id/bank-account",
        data: {
          "accountHolderName": obj.accountHolderName,
          "accountNumber": obj.accountNumber,
          "bankName": obj.bankName,
          "routingNumber": obj.routingNumber,
          "accountType": obj.accountType,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> saveVehicle(
    SaveVehicleReqBodyModel obj,
    String id,
  ) async {
    try {
      final response = await dioClient.post(
        "${Endpoints.baseUrl}/provider/$id/vehicle",
        data: {
          "manufacturer": obj.manufacturer,
          "model": obj.model,
          "numberPlate": obj.numberPlate,
          "isActive": true,
          "vin": obj.vin,
          "insurance": {
            "insurerName": obj.insurance?.insurerName,
            "policyExpiryDate": obj.insurance?.policyExpiryDate,
            "policyStartDate": obj.insurance?.policyStartDate,
            "providerUniqueId": obj.providerUniqueId,
            "isActive": true,
            "policyType": {
              "id": obj.insurance?.policyType?.id,
              "name": obj.insurance?.policyType?.name,
              "isActive": obj.insurance?.policyType?.isActive,
            },
            "policyHolderName": obj.insurance?.policyHolderName,
            "policyNumber": obj.insurance?.policyNumber,
            "imagePath": obj.insurance?.imagePath
          },
          "providerUniqueId": obj.providerUniqueId,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> saveLicense(
    SaveLicenseReqBodyModel obj,
    String id,
  ) async {
    try {
      final response = await dioClient.post(
        "${Endpoints.baseUrl}/provider/$id/license",
        data: {
          "issuedBy": obj.issuedBy,
          "registeredState": obj.registeredState,
          "licenseType": {
            "id": obj.licenseType?.id,
            "name": obj.licenseType?.name,
            "isActive": obj.licenseType?.isActive,
          },
          "licenseNumber": obj.licenseNumber,
          "licenseStartDate": obj.licenseStartDate,
          "licenseExpiryDate": obj.licenseExpiryDate,
          "licenseHolderName": obj.licenseHolderName,
          "isActive": obj.isActive,
          "providerUniqueId": obj.providerUniqueId,
          "imagePath": obj.imagePath,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> saveInsurance(
    SaveInsuranceReqBodyModel obj,
    String id,
  ) async {
    try {
      final response = await dioClient.post(
        "${Endpoints.baseUrl}/provider/$id/insurance",
        data: {
          "insurerName": obj.insurerName,
          "policyType": {
            "id": obj.policyType!.id,
            "name": obj.policyType!.name,
            "isActive": obj.policyType!.isActive
          },
          "policyNumber": obj.policyNumber,
          "policyStartDate": obj.policyStartDate,
          "policyExpiryDate": obj.policyExpiryDate,
          "policyHolderName": obj.policyHolderName,
          "isActive": obj.isActive,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> saveIndividual(
    SaveCompanyDetailReqBodyModel obj,
    String id,
  ) async {
    try {
      final response = await dioClient
          .post("${Endpoints.baseUrl}/provider/$id/individual", data: {
        "companyName": obj.companyName,
        "companyPhone": obj.companyPhone,
        "companyEmail": obj.companyEmail,
        "companyWebsite": obj.companyWebsite,
        "address": {
          "house": obj.address!.house,
          "building": obj.address!.building,
          "street": obj.address!.street,
          "county": obj.address!.county,
          "district": obj.address!.district,
          "country": obj.address!.country,
          "zipcode": obj.address!.zipcode,
          "latitude": obj.address!.latitude,
          "longitude": obj.address!.longitude,
          "altitude": obj.address!.altitude,
        },
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> saveSelectedCategory(
    CategoryModel obj,
    String id,
  ) async {
    try {
      final response = await dioClient.post(
        "${Endpoints.baseUrl}/provider/$id/category",
        data: {
          "id": obj.id,
          "residentialService": obj.residentialService,
          "commercialService": obj.commercialService,
          "timeslots": obj.timeslots,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCategory() async {
    try {
      final Response response = await dioClient.get(
        "${Endpoints.baseUrl}/category",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> refreshToken(
    String token,
    String expiryDate,
    String username,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/auth/refreshtoken",
        data: {
          "refreshToken": {"token": token, "expiryDate": expiryDate},
          "username": username
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> authToken(
    String userName,
    String password,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/auth/token",
        data: {
          "username": userName,
          "password": password,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> forgotPasswordSendOtp(
    String userName,
  ) async {
    try {
      final Response response = await dioClient.get(
        "${Endpoints.baseUrl}/auth/password/forgot/$userName",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> resetPassword(
    String userId,
    String password,
    String otp,
  ) async {
    try {
      final Response response = await dioClient.put(
        "${Endpoints.baseUrl}/auth/password/reset",
        data: {
          "username": userId,
          "password": password,
          "otp": otp,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> changePassword(
    String userId,
    String oldPassword,
    String password,
  ) async {
    try {
      final Response response = await dioClient.put(
        "${Endpoints.baseUrl}/auth/password/change",
        data: {
          "username": userId,
          "oldPassword": oldPassword,
          "newPassword": password,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addNewProvider(
    String emailId,
    String password,
    bool isIndividual,
  ) async {
    try {
      final Response response = await dioClient.post(
        "${Endpoints.baseUrl}/provider/signup",
        data: {
          "name": emailId,
          "website": "",
          "email": emailId,
          "phone": "",
          "userLoginDetails": {
            "username": emailId,
            "password": password,
          },
          "isIndividual": isIndividual
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
