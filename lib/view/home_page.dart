import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_battles/view/pdf_from_asset.dart';
import 'package:pdf_battles/view/settings_page.dart';

import '../common/constants/error_screen.dart';
import '../common/constants/loader.dart';
import '../controller/sharing_intent_controller.dart';
import 'history_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  String path = "";
  // final platform = MethodChannel(PlatformChannelsFlutter.channelNameForPDF);
  void navToSettingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  void navigateToPDfPage(String path) {
    if (path.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerFromFilePath(
            pdfAssetPath: path,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
        break;
      default:
        debugPrint(state.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var _files = ref.watch(intentFilesProvider);
    //   "This Overlay widget cannot be marked as needing to build because the framework is already in the process of building widgets. A …"
    //   "setState() or markNeedsBuild() called during build."
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => path.isNotEmpty ? navigateToPDfPage(path) : null,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Battles'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: navToSettingsPage,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _files.when(
        data: (files) {
          if (files.isNotEmpty) {
            debugPrint(files.toString());
            path = files.first.path;
          }
          return const HistoryPage();
        },
        error: (err, _) => ErrorScreen(
          error: err.toString(),
        ),
        loading: () => const Loader(),
      ),
    );
  }
}
