import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper{
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static configNotification() async{
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: (int id, String title, String body,String payload) async{});
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  static Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  static void eventAlarm(String content) async {
    DateTime scheduledNotificationDateTime=DateTime.now().add(Duration(seconds: 1));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'note_notif',
      'note_notif',
      'Channel for note notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);

    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(0, 'SUCCEED!!!', content,
        scheduledNotificationDateTime, platformChannelSpecifics);
  }

  static void dailyAlarm() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'note_notif',
      'note_notif',
      'Channel for note notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);

    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.showDailyAtTime(1, 'Did you Check the News Today?', 'Check your notes here!!!',
        Time(16,0,0), platformChannelSpecifics);
  }

  static void scheduleAlarm(DateTime date,String content) async {
    int scheduleDate=date.millisecondsSinceEpoch-DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).millisecondsSinceEpoch+300000;
    DateTime scheduledNotificationDateTime=DateTime.now().add(Duration(milliseconds: scheduleDate));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'note_notif',
      'note_notif',
      'Channel for note notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);

    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(3, 'WARNING!!!', content,
        scheduledNotificationDateTime, platformChannelSpecifics);
  }
}