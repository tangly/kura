import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './src/models/medication.dart';
import './src/models/user.dart';
import './src/views/medication_list_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MedicationAdapter());
  Hive.registerAdapter(UserAdapter());
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
