import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/services/repositories/app_repository_validation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/shared_preferences/shared_preference_constants.dart';
import '../../../../core/services/shared_preferences/shared_preference_helper.dart';
import '../../../../utils/app_strings.dart';

class SendingLocationCubit extends Cubit<bool> {
  SendingLocationCubit() : super(false);

  AppRepositoryValidation appRepositoryValidation =
      getIt<AppRepositoryValidation>();

  Future<void> sentProviderLocation(Position position) async {
    String providerId = SharedPreferenceHelper()
        .getStringValue(SharedPreferenceConstants.uniqueId);

    await appRepositoryValidation.providerLocation(
      providerUniqueId: providerId,
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: 0.0,
      landmark: AppStrings.emptyString,
      createdAt: AppStrings.emptyString,
    );
    return;
  }
}
