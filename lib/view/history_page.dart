// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/constants/constants.dart';
import 'pdf_from_asset.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  void setHistoryValue(bool val) {}
  Future<void> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      final String filePath = result.files.single.path!;
      if (filePath.isNotEmpty && filePath.contains('pdf')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerFromAsset(
              pdfAssetPath: filePath,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Please pick a pdf file'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Please pick a pdf file'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    // SwitchListTile(
                    //   value: false,
                    //   title: const Text("Histoy"),
                    //   onChanged: setHistoryValue,
                    // ),
                    Image.asset(
                      emptyImage,
                      fit: BoxFit.fitHeight,
                    ),
                    const Text('It\'s empty in here'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: pickFile,
        label: const Text("Pick a pdf file"),
        icon: const Icon(Icons.file_copy_outlined),
        autofocus: true,
      ),
    );
  }
}
