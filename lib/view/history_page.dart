// ignore_for_file: use_build_context_synchronously
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_battles/common/constants/show_snack_bar_message.dart';
import 'package:pdf_battles/model/hive/pdf_files.dart';
import 'package:pdf_battles/view/carasoul_pdfs_widget.dart';
import 'package:pdf_battles/view/nothing_to_show_widget.dart';
import 'package:pick_or_save/pick_or_save.dart';
import '../controller/history_file_names_controller.dart';
import '../controller/settings_controller.dart';
import 'pdf_from_asset.dart';
import 'package:universal_io/io.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  late String filePath;
  Future<void> pickFile() async {
    if (Platform.isAndroid) {
      List<String>? WithoutCachedResultList = await PickOrSave().filePicker(
        params: FilePickerParams(
            getCachedFilePath: false, mimeTypesFilter: ["application/pdf"]),
      );
      if (WithoutCachedResultList?.length != 0) {
        filePath = WithoutCachedResultList![0];
      }
    } else {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null) {
        filePath = result.files.single.path!;
      } else {
        // User canceled the picker
        showSnackBarMessage(context, "", 'Error: Please pick a pdf file');
      }
    }

    if (filePath.isNotEmpty && filePath.contains('pdf')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerFromFilePath(
            pdfAssetPath: filePath,
          ),
        ),
      );
    } else {
      showSnackBarMessage(context, "", 'Error: Please pick a pdf file');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool _isHistoryOn = ref.watch(historyOnOffProvider);
    final List<PdfFiles> _pdfs = ref.watch(historyFilesProvider);
    return Scaffold(
      body: ((_isHistoryOn == true && _pdfs.isNotEmpty))
          ? CarasoulWidget(
              pdfs: _pdfs,
            )
          : const NothingToShow(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: pickFile,
        label: const Text("Pick a pdf file"),
        icon: const Icon(Icons.file_copy_outlined),
        autofocus: true,
      ),
    );
  }
}
