import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_battles/controller/history_file_names_controller.dart';

class PDFViewerFromFilePath extends ConsumerStatefulWidget {
  const PDFViewerFromFilePath({Key? key, required this.pdfAssetPath})
      : super(key: key);
  final String pdfAssetPath;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PDFViewerFromFilePathState();
}

class _PDFViewerFromFilePathState extends ConsumerState<PDFViewerFromFilePath> {
  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();
  late String fileName;
  final StreamController<String> _pageCountController =
      StreamController<String>();
  @override
  void initState() {
    fileName = File(widget.pdfAssetPath).uri.pathSegments.last.toString();
    ref.read(historyFilesProvider.notifier).addFilePath(widget.pdfAssetPath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        actions: <Widget>[
          StreamBuilder<String>(
              stream: _pageCountController.stream,
              builder: (_, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Colors.blue[900],
                      ),
                      child: Text(snapshot.data!),
                    ),
                  );
                }
                return const SizedBox();
              }),
        ],
      ),
      body: PDF(
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onPageChanged: (int? current, int? total) =>
            _pageCountController.add('${current! + 1} - $total'),
        onViewCreated: (PDFViewController pdfViewController) async {
          _pdfViewController.complete(pdfViewController);
          final int currentPage = await pdfViewController.getCurrentPage() ?? 0;
          final int? pageCount = await pdfViewController.getPageCount();
          _pageCountController.add('${currentPage + 1} - $pageCount');
        },
      ).fromPath(
        widget.pdfAssetPath,
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _pdfViewController.future,
        builder: (_, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: '<',
                  child: const Text(
                    '<',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () async {
                    final PDFViewController pdfController = snapshot.data!;
                    final int currentPage =
                        (await pdfController.getCurrentPage())! - 1;
                    if (currentPage >= 0) {
                      await pdfController.setPage(currentPage);
                    }
                  },
                ),
                FloatingActionButton(
                  heroTag: '>',
                  child: const Text(
                    '>',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () async {
                    final PDFViewController pdfController = snapshot.data!;
                    final int currentPage =
                        (await pdfController.getCurrentPage())! + 1;
                    final int numberOfPages =
                        await pdfController.getPageCount() ?? 0;
                    if (numberOfPages > currentPage) {
                      await pdfController.setPage(currentPage);
                    }
                  },
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
