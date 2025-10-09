import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kura/l10n/app_localizations.dart';
import 'package:kura/src/models/medication.dart';
import 'package:kura/src/models/user.dart';
import 'package:kura/src/services/notification_service_impl.dart';
import 'package:kura/src/views/medication_list_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MedicationAdapter());
  Hive.registerAdapter(UserAdapter());
  final notificationService = NotificationServiceImpl(notificationsPlugin: FlutterLocalNotificationsPlugin());
  await notificationService.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1193d4);

    final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        surface: const Color(0xFFf6f7f8),
      ),
      scaffoldBackgroundColor: const Color(0xFFf6f7f8),
      textTheme: GoogleFonts.interTextTheme(),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),
    );

    final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        surface: const Color(0xFF101c22),
      ),
      scaffoldBackgroundColor: const Color(0xFF101c22),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: const Color(0x80111827), // background-dark-900 with 50% opacity
      ),
    );

    return MaterialApp(
      title: 'Medication Manager',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MedicationListScreen(),
    );
  }
}
