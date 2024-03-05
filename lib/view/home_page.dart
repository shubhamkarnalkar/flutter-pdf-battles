// ignore_for_file: use_build_context_synchronously, override_on_non_overriding_member

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_battles/common/constants/platform_channels.dart';
import 'package:pdf_battles/view/pdf_from_asset.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  final platform = MethodChannel(PlatformChannelsFlutter.channelNameForPDF);
  late StreamSubscription _intentSub;
  final _sharedFiles = <SharedMediaFile>[];

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Listen to media sharing coming from outside the app while the app is in the memory.
    _intentSub = ReceiveSharingIntent.getMediaStream().listen((value) {
      _sharedFiles.clear();
      _sharedFiles.addAll(value);
      // debugPrint(_sharedFiles.map((f) => f.toMap()) );
    }, onError: (err) {
      // debugPrint("getIntentDataStream error: $err");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.hourglass_empty),
              Text("Error:$err"),
            ],
          ),
        ),
      );
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.getInitialMedia().then((value) {
      _sharedFiles.clear();
      _sharedFiles.addAll(value);
      // debugPrint(_sharedFiles.map((f) => f.toMap() ) );
      List<String> listPdfs = [];
      for (final SharedMediaFile file in _sharedFiles) {
        file.mimeType == "application/pdf" ? listPdfs.add(file.path) : null;
      }
      if (listPdfs.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerFromAsset(
              pdfAssetPath: listPdfs.first.toString(),
            ),
          ),
        );
      }
      // Tell the library that we are done processing the intent.
      ReceiveSharingIntent.reset();
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _intentSub.cancel();
    super.didChangeAppLifecycleState(state);
    // if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Specially Designed For Maitreya",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                ),
              ),
              SizedBox(
                height: 30,
              ),
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
