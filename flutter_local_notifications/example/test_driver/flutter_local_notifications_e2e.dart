import 'dart:io';

import 'package:e2e/e2e.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  E2EWidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  group('resolvePlatformSpecificImplementation()', () {
    setUpAll(() async {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      final initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');
      final initializationSettingsIOS = IOSInitializationSettings();
      final initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    });

    if (Platform.isIOS) {
      testWidgets('Can resolve iOS plugin implementation when running on iOS',
          (WidgetTester tester) async {
        expect(
            flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    IOSFlutterLocalNotificationsPlugin>(),
            isA<IOSFlutterLocalNotificationsPlugin>());
      });
    }

    if (Platform.isAndroid) {
      testWidgets(
          'Can resolve Android plugin implementation when running on Android',
          (WidgetTester tester) async {
        expect(
            flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>(),
            isA<AndroidFlutterLocalNotificationsPlugin>());
      });
    }

    if (Platform.isIOS) {
      testWidgets(
          'Returns null trying to resolve Android plugin implementation when running on iOS',
          (WidgetTester tester) async {
        expect(
            flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>(),
            isNull);
      });
    }
    if (Platform.isAndroid) {
      testWidgets(
          'Returns null trying to resolve iOS plugin implementation when running on Android',
          (WidgetTester tester) async {
        expect(
            flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    IOSFlutterLocalNotificationsPlugin>(),
            isNull);
      });
    }

    testWidgets('Throws argument error requesting base class type',
        (WidgetTester tester) async {
      expect(
          () => flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation(),
          throwsArgumentError);
    });
  });
}
