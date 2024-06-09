import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_battles/controller/settings_controller.dart';

class PDFViewerFromFilePathWidget extends ConsumerWidget {
  final String pdfAssetPath;
  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();
  PDFViewerFromFilePathWidget({required this.pdfAssetPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PDF(
      nightMode: identical(ref.watch(themeModeProvider), ThemeMode.dark),
      onViewCreated: (PDFViewController pdfViewController) async {
        // final int numberOfPages = await pdfViewController.getPageCount() ?? 0;
        // if (numberOfPages >= 1) pdfViewController.setPage(1);
        _pdfViewController.complete(pdfViewController);
      },
    ).fromPath(
      pdfAssetPath,
    );
  }
}
