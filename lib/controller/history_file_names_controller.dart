import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf_battles/model/hive/pdf_files.dart';
import '../common/constants/constants.dart';

final filesBoxProvider = Provider((ref) {
  return Hive.box<PdfFiles>(filesBox);
});

final historyFilesNotifierProvider = StreamProvider.autoDispose((ref) async* {
  yield ref.read(filesBoxProvider).listenable();
});

final historyFilesProvider =
    StateNotifierProvider<HistoryFileNamesNotifier, List<PdfFiles>>((ref) {
  return HistoryFileNamesNotifier(filesBoxVal: ref.read(filesBoxProvider));
});

class HistoryFileNamesNotifier extends StateNotifier<List<PdfFiles>> {
  final Box<PdfFiles> _filesBoxVal;
  HistoryFileNamesNotifier({required Box<PdfFiles> filesBoxVal})
      : _filesBoxVal = filesBoxVal,
        super([]) {
    state = getFilePaths();
  }

  List<PdfFiles> getFilePaths() {
    return _filesBoxVal.values.toList();
  }

  void addFilePath({required String filePath, required String name}) async {
    List<String> _splits = name.split('.');
    final PdfFiles _file = PdfFiles(name: _splits[0], path: filePath);
    if (!_filesBoxVal.containsKey(_splits[0])) {
      await _filesBoxVal.put(_splits[0], _file);
      state = _filesBoxVal.values.toList();
    }
  }
}
