// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf_battles/common/pick_file.dart';
import 'package:pdf_battles/common/utils.dart';
import 'package:pdf_battles/view/pdf_from_file.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  // final platform = MethodChannel(PlatformChannelsFlutter.channelNameForPDF);
  late StreamSubscription _intentSub;
  final _sharedFiles = <SharedMediaFile>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Listen to media sharing coming from outside the app while the app is in the memory.
    ReceiveSharingIntent.getMediaStream().listen((value) {
      _sharedFiles.clear();
      _sharedFiles.addAll(value);
      // debugPrint(__sharedFiles.map((f) => f.toMap()) );
    }, onError: (err) {
      // debugPrint("getIntentDataStream error: $err")
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.getInitialMedia().then((value) {
      _sharedFiles.clear();
      _sharedFiles.addAll(value);
      // debugPrint(__sharedFiles.map((f) => f.toMap() ) );
      List<String> listPdfs = [];
      for (final SharedMediaFile file in _sharedFiles) {
        file.mimeType == "application/pdf" ? listPdfs.add(file.path) : null;
      }
      if (listPdfs.isNotEmpty) {
        return listPdfs.first;
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
    switch (state) {
      case AppLifecycleState.detached:
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.pinkAccent,
                ),
                child: Center(
                  child: SizedBox(
                    width: 400,
                    height: 400,
                    // child: Lottie.asset(carAnimationPath),
                    child: Lottie.network(
                      'https://assets1.lottiefiles.com/private_files/lf30_QLsD8M.json',
                      height: 200.0,
                      repeat: true,
                      reverse: true,
                      animate: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: pickPDFFileAndNavigate,
        label: const Text("Pick a pdf file"),
        icon: const Icon(Icons.file_copy_outlined),
        autofocus: true,
      ),
    );
  }

  Future<void> pickPDFFileAndNavigate() async {
    try {
      pickFile("pdf").then(
        (file) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewFromFile(
              pdfAssetPath: file,
            ),
          ),
        ),
      );
    } catch (e) {
      showSnackBar(context: context, error: e.toString());
    }
  }
}
