import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  init() async{
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('appicon');
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsDarwin,
      android: androidInitializationSettings
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
    );
  }

  onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async{
  }

  showNotification(String title, String content, String id) async{
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker'
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      0, 
      title, 
      content, 
      notificationDetails,
      payload: id
    );
  }
}
