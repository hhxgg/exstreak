import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/database.dart';
import 'data/repositories/settings_repository.dart';
import 'services/notification_service.dart';
import 'state/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // The three async singletons the whole app depends on. Building them before
  // runApp keeps the first frame free of loading states.
  final database = AppDatabase();
  final settings = await SettingsRepository.open();
  final notifications = await NotificationService.create();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        settingsRepositoryProvider.overrideWithValue(settings),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
      child: const ExStreakApp(),
    ),
  );
}
