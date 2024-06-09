import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pdf_battles/controller/history_file_names_controller.dart';
import 'package:universal_io/io.dart';

// ignore: must_be_immutable
class PDFViewerFromFilePath extends ConsumerStatefulWidget {
  PDFViewerFromFilePath({Key? key, required this.pdfAssetPath, this.name = ""})
      : super(key: key);
  final String pdfAssetPath;
  late String name;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PDFViewerFromFilePathState();
}

class _PDFViewerFromFilePathState extends ConsumerState<PDFViewerFromFilePath> {
  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();

  final StreamController<String> _pageCountController =
      StreamController<String>();
  @override
  void initState() {
    if (widget.name.isEmpty) {
      widget.name = File(widget.pdfAssetPath).uri.pathSegments.last.toString();
    }
    ref
        .read(historyFilesProvider.notifier)
        .addFilePath(name: widget.name, filePath: widget.pdfAssetPath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
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
        onError: (error) {
          // debugPrint(error.toString());
          MotionToast.error(
                  title: Text("Permission Error"),
                  description: Text("Go to Settings and give permission"))
              .show(context);
        },
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
                  child: Icon(Icons.arrow_back_ios),
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
                  child: Icon(Icons.arrow_forward_ios),
                  onPressed: () async {
                    final PDFViewController _pdfController = snapshot.data!;
                    final int currentPage =
                        (await _pdfController.getCurrentPage())! + 1;
                    final int numberOfPages =
                        await _pdfController.getPageCount() ?? 0;
                    if (numberOfPages > currentPage) {
                      await _pdfController.setPage(currentPage);
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
