import 'dart:io';
import 'dart:js_interop';
import 'package:flutter/material.dart';

void showSnackBar(
    {required BuildContext context, String? text, String? error}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text((text.isNull ? error : text) ?? ""),
        backgroundColor: text.isNull ? Colors.red : null,
      ),
    );
}

String getFileNameFromPath(String pdfAssetPath) {
  return File(pdfAssetPath).uri.pathSegments.last.toString();
}
