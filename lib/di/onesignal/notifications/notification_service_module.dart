import 'package:get_it/get_it.dart';
import 'package:ni_trades/services/notification_services.dart';

Future<void> init(GetIt injector) async {
  injector.registerLazySingleton(() => NotificationService());
}
