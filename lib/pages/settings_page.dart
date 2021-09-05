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
      builder: (context, provider, _) {
        return ListView(
          children: [
            ListTile(
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
                          context.showSnackbar("Pengingat harian telah aktif",
                              isSuccess: true);
                        } else {
                          context.showSnackbar("Pengingat harian dibatalkan");
                        }
                      } else {
                        context.showSnackbar("Fitur ini belum tersedia");
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
