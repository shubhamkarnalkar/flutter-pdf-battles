import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PDFViewerFromFilePathWidget extends StatelessWidget {
  final String pdfAssetPath;
  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();
  PDFViewerFromFilePathWidget({required this.pdfAssetPath});

  @override
  Widget build(BuildContext context) {
    return PDF(
      autoSpacing: false,
      pageFling: false,
      onViewCreated: (PDFViewController pdfViewController) async {
        _pdfViewController.complete(pdfViewController);
      },
    ).fromPath(
      pdfAssetPath,
    );
  }
}
