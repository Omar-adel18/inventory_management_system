import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Initialize Flutter Local Notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Function to show a notification and store it in Supabase
Future<void> showNotification(int id, String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'stock_alert_channel',
    'Stock Alerts',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  // Show the local notification
  await flutterLocalNotificationsPlugin.show(
    id, // Use a unique ID for each notification
    title,
    body,
    platformChannelSpecifics,
  );

  // Insert the notification into the Supabase database
  try {
    await Supabase.instance.client
        .from('notifications')
        .insert({
      'title': title,
      'body': body,
      'timestamp': DateTime.now().toIso8601String(),
    });

    print('Notification stored in Supabase successfully');
  } catch (e) {
    print('Error storing notification in Supabase: $e');
  }

  // Wait for 3 seconds
  await Future.delayed(Duration(seconds: 3));
}