import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/global.dart';
import 'package:flutter_restaurant/pages/detail_page.dart';
import 'package:flutter_restaurant/pages/favorite_page.dart';
import 'package:flutter_restaurant/pages/home_page.dart';
import 'package:flutter_restaurant/pages/settings_page.dart';
import 'package:flutter_restaurant/utils/notification_helper.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _bottomNavIndex = 0;
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _notificationHelper.handleNotification(DetailPage.routeName);
  }

  @override
  void dispose() {
    selectedPayloadSubject.close();
    super.dispose();
  }

  final _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: HomePage.title,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: FavoritePage.title,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: SettingsPage.title,
    ),
  ];

  final _listWidgets = [
    HomePage(),
    FavoritePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidgets[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavBarItems,
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}
