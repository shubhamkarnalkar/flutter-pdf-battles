// ignore_for_file: use_build_context_synchronously
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_battles/common/constants/providers.dart';
import 'package:pdf_battles/common/constants/show_snack_bar_message.dart';
import 'package:pdf_battles/controller/view_controller.dart';
import 'package:pdf_battles/model/hive/pdf_files.dart';
import 'package:pdf_battles/view/carasoul_pdfs_widget.dart';
import 'package:pdf_battles/view/list_view_history.dart';
import 'package:pdf_battles/view/loading_page.dart';
import 'package:pdf_battles/view/nothing_to_show_widget.dart';
import 'package:pdf_battles/view/permission_error_page.dart';
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
  late String _fileName;
  Future<void> pickFile() async {
    if (Platform.isAndroid) {
      List<String>? WithoutCachedResultList = await PickOrSave().filePicker(
        params: FilePickerParams(
            getCachedFilePath: false, mimeTypesFilter: ["application/pdf"]),
      );
      if (WithoutCachedResultList!.isNotEmpty) {
        final FileMetadata _metaData = await PickOrSave().fileMetaData(
            params: FileMetadataParams(filePath: WithoutCachedResultList[0]));
        filePath = WithoutCachedResultList[0];
        _fileName =
            File(_metaData.displayName!).uri.pathSegments.last.toString();
        ;
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

    if (filePath.isNotEmpty && _fileName.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerFromFilePath(
            pdfAssetPath: filePath,
            name: _fileName,
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
    final bool _isLoading = ref.watch(loadingProvider).isLoading;
    final UIViewTypeHistoryPage _uiView = ref.watch(UIViewProvider);
    return Scaffold(
      appBar: _isHistoryOn && _pdfs.isNotEmpty
          ? AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    ref.read(UIViewProvider.notifier).setView(_uiView);
                  },
                  icon: Icon(_uiView == UIViewTypeHistoryPage.List
                      ? Icons.list_alt
                      : Icons.camera_rear_outlined),
                ),
              ],
            )
          : null,
      body: ref.watch(permissionProvider).when(
            data: (d) => _isLoading
                ? LoadingWidget()
                : ((_isHistoryOn == true && _pdfs.isNotEmpty))
                    ? _uiView == UIViewTypeHistoryPage.Carasoul
                        ? CarasoulWidget(
                            key: UniqueKey(),
                            pdfs: _pdfs,
                          )
                        : ListViewHistory(
                            files: _pdfs,
                          )
                    : const NothingToShow(),
            error: (error, stackTrace) => PermissionErrorPage(
              errorMessage: error.toString(),
            ),
            loading: () => Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
      floatingActionButton: _isLoading
          ? SizedBox()
          : FloatingActionButton.extended(
              heroTag: 'pick',
              onPressed: pickFile,
              label: const Text("Pick a pdf file"),
              icon: const Icon(Icons.file_copy_outlined),
              autofocus: true,
            ),
    );
  }
}
