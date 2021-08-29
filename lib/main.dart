import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/constant.dart';
import 'package:flutter_restaurant/pages/detail_page.dart';
import 'package:flutter_restaurant/pages/home_page.dart';
import 'package:flutter_restaurant/pages/splash_page.dart';
import 'package:flutter_restaurant/provider/detail_provider.dart';
import 'package:flutter_restaurant/provider/list_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ListProvider>(create: (_) => ListProvider()),
        ChangeNotifierProvider<DetailProvider>(create: (_) => DetailProvider()),
      ],
      child: MaterialApp(
        title: Constant.appName,
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashPage.routeName,
        routes: {
          SplashPage.routeName: (c) => SplashPage(),
          HomePage.routeName: (c) => HomePage(),
          DetailPage.routeName: (c) => DetailPage()
        },
      ),
    );
  }
}
