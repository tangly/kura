import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kura/src/services/notification_service.dart';
import 'package:kura/src/services/notification_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'notification_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FlutterLocalNotificationsPlugin>()])
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
    when(mockFlutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation()).thenReturn(null);
    await notificationService.init();
    verify(mockFlutterLocalNotificationsPlugin.initialize(any));
  });

  
}
