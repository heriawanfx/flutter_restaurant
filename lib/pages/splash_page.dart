import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/constant.dart';
import 'package:flutter_restaurant/common/navigation.dart';
import 'package:flutter_restaurant/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/splash';
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future _startTime() async {
    var duration = Duration(seconds: 2);
    return Timer(duration, _navigateToHome);
  }

  void _navigateToHome() {
    Navigation.pushNamed(HomePage.routeName, replacement: true);
  }

  @override
  void initState() {
    super.initState();

    _startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu_outlined,
              size: 50,
              color: Colors.white,
            ),
            Text(
              Constant.appName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
