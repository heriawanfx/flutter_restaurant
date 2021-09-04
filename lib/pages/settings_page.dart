import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/preference_provider.dart';
import 'package:flutter_restaurant/provider/reminder_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_restaurant/utils/context_ext.dart';

class SettingsPage extends StatelessWidget {
  static const String title = 'Setelan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<PreferenceProvider>(
      builder: (context, provider, child) {
        return ListView(
          children: [
            Material(
              child: ListTile(
                  title: Text("Scheduling News"),
                  trailing: Consumer<ReminderProvider>(
                    builder: (context, reminder, _) {
                      return Switch.adaptive(
                        value: provider.isReminderDaily,
                        onChanged: (value) async {
                          if (Platform.isIOS) {
                            context.showSnackbar("Fitur ini belum tersedia");
                          } else {
                            provider.setDailyRemainder(value);
                            reminder.setReminder(value);
                          }
                        },
                      );
                    },
                  )),
            )
          ],
        );
      },
    );
  }
}
