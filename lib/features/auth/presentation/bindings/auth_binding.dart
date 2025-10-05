import 'package:get/get.dart';
import 'package:vally_app/core/network/api_service.dart';
import 'package:vally_app/features/auth/data/datasources/remote/auth_remote_datasource_impl.dart';
import 'package:vally_app/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:vally_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vally_app/features/auth/domain/repositories/auth.repository.dart';
import 'package:vally_app/features/auth/application/use-cases/login.use-cases.dart';
import 'package:vally_app/features/auth/presentation/controller/login.controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());

    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(Get.find<ApiService>()),
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(remote: Get.find<AuthRemoteDataSource>()),
    );

    Get.lazyPut<LoginUserCase>(
      () => LoginUserCase(Get.find<AuthRepository>()),
    );

    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<LoginUserCase>()),
    );
  }
}
