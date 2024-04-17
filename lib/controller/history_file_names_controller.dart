import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../common/constants/constants.dart';

final filesBoxProvider = Provider((ref) {
  return Hive.box(filesBox);
});

final historyFilesNotifierProvider = StreamProvider.autoDispose((ref) async* {
  yield ref.read(filesBoxProvider).listenable();
});

final historyFilesProvider =
    StateNotifierProvider<HistoryFileNamesNotifier, List<String>>((ref) {
  return HistoryFileNamesNotifier(filesBoxVal: ref.read(filesBoxProvider));
});

class HistoryFileNamesNotifier extends StateNotifier<List<String>> {
  final Box<dynamic> filesBoxVal;
  HistoryFileNamesNotifier({required this.filesBoxVal}) : super([]) {
    state = getFilePaths();
  }

  List<String> getFilePaths() {
    // state = filesBoxVal.get(historyFiles) ?? [];
    return filesBoxVal.get(historyFiles) ?? [];
  }

  void addFilePath(String filePath) {
    final fileValues = getFilePaths();
    if (!fileValues.contains(filePath)) {
      fileValues.add(filePath);
      filesBoxVal.put(historyFiles, fileValues);
      state = fileValues;
    }
  }
}
