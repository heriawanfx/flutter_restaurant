import 'package:flutter/material.dart';

extension ExtensionContext on BuildContext {
  showSnackbar(String message,
      {bool isSuccess = false, SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
          backgroundColor:
              isSuccess ? Colors.green.shade600 : Colors.grey.shade800,
          content: Text(message),
          action: action),
    );
  }
}
