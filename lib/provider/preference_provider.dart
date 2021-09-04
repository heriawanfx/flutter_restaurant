import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utils/preference_helper.dart';

class PreferenceProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferenceProvider({required this.preferencesHelper}) {
    _getDailyReminder();
  }

  bool _isDailyReminder = false;
  bool get isReminderDaily => _isDailyReminder;

  void _getDailyReminder() async {
    _isDailyReminder = await preferencesHelper.isDailyNewsActive;
    notifyListeners();
  }

  void setDailyRemainder(bool value) {
    preferencesHelper.setDailyReminder(value);
    _getDailyReminder();
  }
}
