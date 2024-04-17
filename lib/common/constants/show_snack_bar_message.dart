import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext ctx, String message, String error) {
  ScaffoldMessenger.of(ctx)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: message.isNotEmpty ? Text(message) : Text(error),
        duration: const Duration(seconds: 2),
        backgroundColor:
            message.isNotEmpty ? Theme.of(ctx).primaryColor : Colors.red,
      ),
    );
}
