import 'package:flutter_test/flutter_test.dart';
import '../../lib/utils/app_constant.dart';

void main() {
  group('AppConstants', () {
    test('should have correct application name', () {
      expect(AppConstants.applicationName, equals('HELP'));
    });

    test('should have correct app version', () {
      expect(AppConstants.appVersion, equals('1.2.10'));
    });

    test('should have correct font family', () {
      expect(AppConstants.fontFamily, equals('Roboto'));
    });

    test('should have correct development URL', () {
      expect(AppConstants.developmentURL, equals('http://localhost:8080'));
    });

    test('should have correct admin dashboard URL', () {
      expect(AppConstants.helpAmPmCom, equals('http://localhost:4200/'));
    });

    test('should have correct default location', () {
      expect(AppConstants.defaultLatLng.latitude, equals(28.628151));
      expect(AppConstants.defaultLatLng.longitude, equals(77.367783));
    });

    test('should have correct date formats', () {
      expect(AppConstants.dateFormatMMDDYYYY, equals('MM-dd-yyyy'));
      expect(AppConstants.dateFormatDDMMYYYY, equals('dd-MM-yyyy'));
      expect(AppConstants.dateFormatHHMMA, equals('hh:mm a'));
    });

    test('should have correct route service URL', () {
      expect(AppConstants.routeServiceURL, 
          equals('https://api.openrouteservice.org/v2/directions/'));
    });

    test('should have correct map API key', () {
      expect(AppConstants.mapAPIKey, 
          equals('AIzaSyAJ-H6Mxxzq17dMgmJnMRMpNjnOC8f78kA'));
    });

    test('should have correct language codes', () {
      expect(AppConstants.enLangCode, equals('en'));
      expect(AppConstants.usCountryCode, equals('US'));
      expect(AppConstants.esLangCode, equals('es'));
      expect(AppConstants.esCountryCode, equals('ES'));
    });

    test('should have correct currency symbols', () {
      expect(AppConstants.dollor, equals('DOLLOR'));
      expect(AppConstants.dollorSign, equals('\$'));
    });

    test('should have correct service categories', () {
      expect(AppConstants.hvac, equals('hvac'));
      expect(AppConstants.electrical, equals('electrical'));
      expect(AppConstants.locksmith, equals('locksmith'));
      expect(AppConstants.plumbing, equals('plumbing'));
    });

    test('should have correct user roles', () {
      expect(AppConstants.superAdmin, equals('ROLE_SUPERADMIN'));
      expect(AppConstants.customer, equals('ROLE_CUSTOMER'));
      expect(AppConstants.provider, equals('ROLE_PROVIDER_ADMIN'));
      expect(AppConstants.providerEmployee, equals('ROLE_PROVIDER_EMPLOYEE'));
    });

    test('should have correct navigation items', () {
      expect(AppConstants.history, equals('history'));
      expect(AppConstants.schedule, equals('SCHEDULED'));
      expect(AppConstants.notifications, equals('notifications'));
      expect(AppConstants.helpNSupport, equals('helpNSupport'));
    });
  });
} 