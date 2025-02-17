import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    // 移除 const 关键字
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1',
      '番剧更新',
      channelDescription: '番剧更新推送',
      importance: Importance.max, // 重要性最高
      priority: Priority.high, // 优先级高
      showWhen: false,
      fullScreenIntent: true, // 悬浮通知
      enableVibration: true, // 开启震动
      // 震动模式，这里设置为震动 1 秒，间隔 1 秒，再震动 1 秒
      vibrationPattern: Int64List.fromList([1000, 1000, 1000]),
      playSound: true, // 播放声音
      visibility: NotificationVisibility.public, // 在锁定屏幕上显示
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'), // 大图标
      icon: '@mipmap/ic_launcher', // 小图标
      styleInformation: BigTextStyleInformation(''), // 文本样式
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    int id = DateTime.now().millisecondsSinceEpoch;
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
