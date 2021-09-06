import 'package:flutter_restaurant/common/global.dart';

class Navigation {
  static pushNamed(String routeName,
      {bool replacement = false, Object? arguments}) {
    if (replacement) {
      navigatorKey.currentState
          ?.pushReplacementNamed(routeName, arguments: arguments);
    } else {
      navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
    }
  }

  static pop() => navigatorKey.currentState?.pop();
}
