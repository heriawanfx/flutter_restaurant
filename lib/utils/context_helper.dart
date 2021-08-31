import 'package:flutter/material.dart';

extension ExtensionContext on BuildContext {
  showSnackbar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}
