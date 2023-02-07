import 'package:get_it/get_it.dart';
import 'package:virtual_officine/services/navigation_service.dart';

GetIt locator = GetIt.instance;


void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}