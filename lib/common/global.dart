import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showSnackbar(String message,
    {bool isSuccess = false, SnackBarAction? action}) {
  final bgColor = isSuccess ? Colors.green.shade600 : Colors.grey.shade800;

  scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: bgColor,
      content: Text(message),
      action: action,
      duration: Duration(seconds: 2),
    ),
  );
}

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

final selectedPayloadSubject = BehaviorSubject<String>();
