import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:helpampm/core/services/repositories/app_services.dart';
import 'media/media_service_handler.dart';
import 'media/media_service.dart';
import 'network/dio_client.dart';
import 'permission/permission_service_handler.dart';
import 'permission/permission_service.dart';
import 'repositories/app_repository.dart';
import 'repositories/app_repository_validation.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  /// Permission service is used in FileUploaderService so it must be located first
  getIt.registerSingleton<PermissionService>(PermissionServiceHandler());
  getIt.registerSingleton<MediaService>(MediaServiceHandler());

  getIt.registerSingleton(Dio());
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  getIt.registerSingleton(AppServices(dioClient: getIt<DioClient>()));

  getIt.registerSingleton(AppRepository(getIt.get<AppServices>()));
  getIt.registerSingleton(AppRepositoryValidation(getIt.get<AppRepository>()));
}
