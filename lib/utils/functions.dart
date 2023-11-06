import 'package:flutter/material.dart';

void showSnackbarMessage(String message, BuildContext context) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
