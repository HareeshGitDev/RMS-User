import 'package:RentMyStay_user/utils/service/deep_linking_service.dart';
import 'package:RentMyStay_user/utils/service/navigator_key_service.dart';
import 'package:get_it/get_it.dart';

GetIt lazySingletonInstance = GetIt.instance;

void lateInitializeServices() {
  lazySingletonInstance.registerLazySingleton(() => NavigatorKeyService());
  lazySingletonInstance.registerLazySingleton(() => DeepLinkingService());
}
