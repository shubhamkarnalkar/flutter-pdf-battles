import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf_battles/model/hive/pdf_files.dart';
import 'package:pdf_battles/model/loading_model.dart';
import 'package:pdf_battles/view/loading_page.dart';
import '../common/constants/constants.dart';

final filesBoxProvider = Provider((ref) {
  return Hive.box<PdfFiles>(filesBox);
});

final historyotifierProvider = StreamProvider.autoDispose((ref) async* {
  yield ref.read(filesBoxProvider).listenable();
});

final historyFilesProvider =
    StateNotifierProvider<HistoryFileNamesNotifier, List<PdfFiles>>((ref) {
  return HistoryFileNamesNotifier(
      ref: ref, filesBoxVal: ref.read(filesBoxProvider));
});

class HistoryFileNamesNotifier extends StateNotifier<List<PdfFiles>> {
  final Box<PdfFiles> _filesBoxVal;
  final Ref _ref;
  HistoryFileNamesNotifier(
      {required Box<PdfFiles> filesBoxVal, required Ref ref})
      : _filesBoxVal = filesBoxVal,
        _ref = ref,
        super([]) {
    state = getFilePaths(isSorted: true);
  }

  List<PdfFiles> getFilePaths({bool isSorted = false}) {
    final list = _filesBoxVal.values.toList();
    if (isSorted) {
      list.sort((a, b) {
        if (a.isPinned && !b.isPinned) {
          return -1; // `a` comes before `b`
        } else if (!a.isPinned && b.isPinned) {
          return 1; // `b` comes before `a`
        } else {
          return 0; // No change in order
        }
      });
    }
    return list;
  }

  void clearBox() async {
    _ref.read(loadingProvider.notifier).state =
        LoadingModel(message: 'Clearing the history', isLoading: true);
    await _filesBoxVal.clear();
    state = getFilePaths();
    _ref.read(loadingProvider.notifier).state = LoadingModel();
  }

  void changePinnedStatus(bool isOn, String name) {
    if (_filesBoxVal.containsKey(name)) {
      _ref.read(loadingProvider.notifier).state =
          LoadingModel(message: 'Changing pinned items', isLoading: true);
      try {
        final PdfFiles _file =
            _filesBoxVal.values.firstWhere((x) => x.name == name);
        _file.isPinned = !isOn;
        _filesBoxVal.put(_file.name, _file);
        state = getFilePaths(isSorted: true);
      } catch (e) {}
      _ref.read(loadingProvider.notifier).state = LoadingModel();
    }
  }

  void addFilePath({required String filePath, required String name}) async {
    List<String> _splits = name.split('.');
    final PdfFiles _file = PdfFiles(name: _splits[0], path: filePath);
    if (!_filesBoxVal.containsKey(_splits[0])) {
      await _filesBoxVal.put(_splits[0], _file);
      state = getFilePaths(isSorted: true);
    }
  }
}
