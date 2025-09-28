import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
    return MaterialApp(
      title: 'Medication Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MedicationListScreen(),
    );
  }
}
