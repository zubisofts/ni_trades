import 'package:get_it/get_it.dart';
import 'package:ni_trades/di/onesignal/notifications/notification_service_module.dart' as NotificationServiceModule;


final GetIt injector = GetIt.instance;

Future<void> init() async {
  // Notification Module
  await NotificationServiceModule.init(injector);
}