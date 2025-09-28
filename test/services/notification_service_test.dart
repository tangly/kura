import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kura/src/services/notification_service.dart';
import 'package:kura/src/services/notification_service_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'notification_service_test.mocks.dart';

@GenerateMocks([FlutterLocalNotificationsPlugin])
void main() {
  late NotificationService notificationService;
  late MockFlutterLocalNotificationsPlugin mockFlutterLocalNotificationsPlugin;

  setUp(() {
    tz.initializeTimeZones();
    mockFlutterLocalNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
    notificationService = NotificationServiceImpl(
      notificationsPlugin: mockFlutterLocalNotificationsPlugin,
    );
  });

  test('init should initialize the plugin', () async {
    when(
      mockFlutterLocalNotificationsPlugin.initialize(any),
    ).thenAnswer((_) async => true);
    await notificationService.init();
    verify(mockFlutterLocalNotificationsPlugin.initialize(any));
  });

  test('scheduleNotification should schedule a notification', () async {
    when(
      mockFlutterLocalNotificationsPlugin.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
      ),
    ).thenAnswer((_) async => Future.value());

    await notificationService.scheduleNotification(
      id: 1,
      title: 'title',
      body: 'body',
      scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
    );

    verify(
      mockFlutterLocalNotificationsPlugin.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
      ),
    );
  });
}
