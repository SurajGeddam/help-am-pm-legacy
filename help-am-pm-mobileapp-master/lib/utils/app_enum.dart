import 'package:helpampm/utils/app_constant.dart';

enum Currency { dollar }

enum TextFormFieldType {
  number,
  name,
  email,
  phone,
  text,
  postalCode,
  price,
  employer,
}

extension CurrencyExtension on Currency {
  String get name {
    switch (this) {
      case Currency.dollar:
        return AppConstants.dollor;
    }
  }

  String get symbol {
    switch (this) {
      case Currency.dollar:
        return AppConstants.dollorSign;
    }
  }
}

enum FileUploadPurpose {
  providerInsurance,
  providerLicense,
  customerOrder,
  userProfile,
}

extension FileUploadPurposeExtension on FileUploadPurpose {
  String get name {
    switch (this) {
      case FileUploadPurpose.providerInsurance:
        return AppConstants.providerInsurance;
      case FileUploadPurpose.providerLicense:
        return AppConstants.providerLicense;
      case FileUploadPurpose.customerOrder:
        return AppConstants.customerOrder;
      case FileUploadPurpose.userProfile:
        return AppConstants.userProfile;
    }
  }
}

enum DrawerType {
  orderHistory,
  scheduleOrders,
  ongoingOrders,
  savedAddress,
  savedCard,
  invite,
  notifications,
  helpNSupport,
  contactUs,
  logOut,
}

extension DrawerTypeExtension on DrawerType {
  String get type {
    switch (this) {
      case DrawerType.orderHistory:
        return AppConstants.history;
      case DrawerType.scheduleOrders:
        return AppConstants.schedule;
      case DrawerType.ongoingOrders:
        return AppConstants.ongoingOrders;
      case DrawerType.savedAddress:
        return AppConstants.savedAddress;
      case DrawerType.savedCard:
        return AppConstants.savedCard;
      case DrawerType.invite:
        return AppConstants.invite;
      case DrawerType.notifications:
        return AppConstants.notifications;
      case DrawerType.helpNSupport:
        return AppConstants.helpNSupport;
      case DrawerType.contactUs:
        return AppConstants.contactUs;
      case DrawerType.logOut:
        return AppConstants.logOut;
    }
  }
}

enum OrdersType { history, schedule }

extension OrderTypeExtension on OrdersType {
  String get type {
    switch (this) {
      case OrdersType.history:
        return AppConstants.history;
      case OrdersType.schedule:
        return AppConstants.schedule;
    }
  }
}

enum InputFormType {
  individual,
  insurance,
  businessLicense,
  tradeLicense,
  vehicle,
  bank,
  proTeamMembers,
}

extension InputFormTypeExtension on InputFormType {
  String get code {
    switch (this) {
      case InputFormType.individual:
        return AppConstants.individual;
      case InputFormType.insurance:
        return AppConstants.insurance;
      case InputFormType.businessLicense:
        return AppConstants.businessLicense;
      case InputFormType.tradeLicense:
        return AppConstants.tradeLicense;
      case InputFormType.vehicle:
        return AppConstants.vehicle;
      case InputFormType.bank:
        return AppConstants.bank;
      case InputFormType.proTeamMembers:
        return AppConstants.proTeamMembers;
    }
  }
}
