import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:listview_in_blocpattern/notification_setvice/Utils.dart';
import 'package:rxdart/rxdart.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static Future initialize() async {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    ///when app is closed
    final details =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotification.add(details.payload);
    }

    // initialization
    await _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        onNotification.add(payload);
      },
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final largeIconPath = await Utils.downloadFile(
          'https://www.highereducationdigest.com/wp-content/uploads/2022/04/800_480-SpeedLabs-Logo-550x330.jpg',
          'LargeIcon');
      final bigPicturePath = await Utils.downloadFile(
          'https://www.highereducationdigest.com/wp-content/uploads/2022/04/800_480-SpeedLabs-Logo-550x330.jpg',
          'BigPicture');

      final styleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(largeIconPath),
          largeIcon: FilePathAndroidBitmap(bigPicturePath));
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "chatAppInFlutter",
          "chatAppInFlutterchannel",
          importance: Importance.max,
          styleInformation: styleInformation,
          priority: Priority.high,
        ),
      );
 
      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload:
            '${message.data['SenderToken']}#${message.data['ChatRoomID']}#${message.data['Receiver']}',
      );
      print('Payload is this ++++>>>>');
      print(message.data.toString());
    } on Exception catch (e) {
      print(e);
    }
  }
}