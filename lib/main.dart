import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/constant.dart';
import 'package:flutter_restaurant/common/global.dart';
import 'package:flutter_restaurant/data/db/database_helper.dart';
import 'package:flutter_restaurant/pages/detail_page.dart';
import 'package:flutter_restaurant/pages/main_page.dart';
import 'package:flutter_restaurant/provider/favorite_provider.dart';
import 'package:flutter_restaurant/provider/detail_provider.dart';
import 'package:flutter_restaurant/provider/list_provider.dart';
import 'package:flutter_restaurant/provider/preference_provider.dart';
import 'package:flutter_restaurant/provider/reminder_provider.dart';
import 'package:flutter_restaurant/utils/background_service.dart';
import 'package:flutter_restaurant/utils/notification_helper.dart';
import 'package:flutter_restaurant/utils/preference_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.registerPort();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(notificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ListProvider>(
          create: (_) => ListProvider(),
        ),
        ChangeNotifierProvider<DetailProvider>(
          create: (_) => DetailProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReminderProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferenceProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(
            databaseHelper: DatabaseHelper(),
          ),
        )
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: Constant.appName,
        theme: ThemeData(primarySwatch: Colors.red),
        debugShowCheckedModeBanner: false,
        initialRoute: MainPage.routeName,
        routes: {
          MainPage.routeName: (c) => MainPage(),
          DetailPage.routeName: (c) => DetailPage()
        },
      ),
    );
  }
}
