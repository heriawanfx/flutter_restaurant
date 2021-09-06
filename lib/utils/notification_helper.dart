import 'dart:convert';
import 'dart:math';

import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_restaurant/common/global.dart';
import 'package:flutter_restaurant/common/navigation.dart';
import 'package:flutter_restaurant/data/models/restaurant.dart';
import 'package:flutter_restaurant/provider/detail_provider.dart';

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin notificationsPlugin) async {
    final androidSettings = AndroidInitializationSettings('app_icon');

    final iOSSettings = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final platformInitializationSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await notificationsPlugin.initialize(platformInitializationSettings,
        onSelectNotification: (String? payload) async {
      selectedPayloadSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin notificationsPlugin,
      List<Restaurant> list) async {
    final channelId = "1";
    final channelName = "channel_01";
    final channelDescription = "dicoding restaurant channel";

    final androidNotificationDetail = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: DefaultStyleInformation(true, true),
    );

    final iOSNotificationDetail = IOSNotificationDetails();
    final platformNotificationDetail = NotificationDetails(
        android: androidNotificationDetail, iOS: iOSNotificationDetail);

    final index = Random().nextInt(list.length - 1);
    //final index = 2;

    final titleNotification = "<b>Dicoding Restaurant</b>";
    final titleNews = list[index].name;

    final articleJson = list[index].toJson();

    await notificationsPlugin.show(
        0, titleNotification, titleNews, platformNotificationDetail,
        payload: jsonEncode(articleJson));
  }

  void handleNotification(String route) {
    selectedPayloadSubject.stream.listen(
      (payload) async {
        final json = jsonDecode(payload);
        final item = Restaurant.fromJson(json);
        Navigation.pushNamed(route);
        scaffoldMessengerKey.currentContext
            ?.read<DetailProvider>()
            .setSelectedId("${item.id}");
      },
    );
  }
}
