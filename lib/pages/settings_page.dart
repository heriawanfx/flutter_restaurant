import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/global.dart';
import 'package:flutter_restaurant/provider/preference_provider.dart';
import 'package:flutter_restaurant/provider/reminder_provider.dart';
import 'package:provider/provider.dart';

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
      builder: (context, provider, _) {
        return ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              title: Text("Pengingat harian"),
              subtitle: Text("Terima rekomendasi restoran setiap pukul 11.00"),
              trailing: Consumer<ReminderProvider>(
                builder: (context, reminder, _) {
                  return Switch(
                    value: provider.isReminderDaily,
                    onChanged: (isChecked) async {
                      if (Platform.isAndroid) {
                        provider.setDailyRemainder(isChecked);
                        reminder.setReminder(isChecked);
                        if (isChecked) {
                          showSnackbar("Pengingat harian telah aktif",
                              isSuccess: true);
                        } else {
                          showSnackbar("Pengingat harian dibatalkan");
                        }
                      } else {
                        showSnackbar("Fitur ini belum tersedia");
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
