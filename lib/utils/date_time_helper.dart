import 'package:flutter_restaurant/common/config.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  DateTimeHelper._();
  static DateTime format() {
    final now = DateTime.now();
    final dateFormat = DateFormat('y/M/d');
    final timeSpecific = Config.getNotificationTime();
    final completeFormat = DateFormat('y/M/d H:m:s');

    final todayDate = dateFormat.format(now);
    final todayDateAndTime = "$todayDate $timeSpecific";
    final resultToday = completeFormat.parseStrict(todayDateAndTime);

    final formatted = resultToday.add(Config.getNotificationInterval());
    final tomorrowDate = dateFormat.format(formatted);
    final tomorrowDateAndTime = "$tomorrowDate $timeSpecific";
    final resultTomorrow = completeFormat.parseStrict(tomorrowDateAndTime);

    return now.isAfter(resultToday) ? resultTomorrow : resultToday;
  }
}
