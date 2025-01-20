import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'dart:async';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationManager {
  Future<List<PendingNotificationRequest>> get notifications =>
      flutterLocalNotificationsPlugin.pendingNotificationRequests();
  static Future initialize() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    AndroidFlutterLocalNotificationsPlugin().requestExactAlarmsPermission();
    tz.initializeTimeZones();
    var androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<int> scheduleNotification(DateTime time, {String desc = ""}) async {
    const AndroidNotificationDetails androidChannelSpecifics =
        AndroidNotificationDetails(
      'CHANNEL_ID_1',
      'CHANNEL_NAME_1',
      channelDescription: 'CHANNEL_DESCRIPTION_1',
      enableLights: true,
      color: Color.fromARGB(255, 255, 0, 0),
      importance: Importance.max,
      priority: Priority.high,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics,
    );
    final int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'TODO',
      'Test Body',
      tz.TZDateTime.from(time, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'Test Payload',
    );

    return notificationId;
  }

  void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
