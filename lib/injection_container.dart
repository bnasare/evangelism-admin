import 'core/prospect/prospect_injection.dart';
import 'src/locales/locale_injection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'shared/platform/network_info.dart';
import 'src/authentication/auth_injection.dart';
import 'src/onboarding/onboarding_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  initAuth();
  initOnboarding();
  initProspect();
  initLocale();

  sl
    ..registerLazySingleton(http.Client.new)
    ..registerLazySingleton<NetworkInfo>(NetworkInfoImpl.new)
    ..registerFactory<FirebaseMessaging>(() => FirebaseMessaging.instance)
    ..registerFactory<FlutterLocalNotificationsPlugin>(
        FlutterLocalNotificationsPlugin.new);

  sl.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());

  await sl.allReady();
}
