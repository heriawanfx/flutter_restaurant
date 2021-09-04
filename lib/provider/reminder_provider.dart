import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/utils/background_service.dart';
import 'package:flutter_restaurant/utils/date_time_helper.dart';

class ReminderProvider extends ChangeNotifier {
  bool _isRemindered = false;

  bool get isRemindered => _isRemindered;

  Future<bool> setReminder(bool value) async {
    _isRemindered = value;
    if (_isRemindered) {
      print('Daily Reminder Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(days: 1),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Daily Reminder Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
