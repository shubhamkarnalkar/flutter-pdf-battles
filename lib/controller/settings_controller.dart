import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf_battles/common/constants/constants.dart';

final settingsProvider = Provider((ref) {
  return Hive.box(settingsBox);
});

final themeModeProvider =
    StateNotifierProvider<ThemeValueNotifier, ThemeData>((ref) {
  return ThemeValueNotifier(ref.read(settingsProvider));
});

final historyOnOffProvider = StateNotifierProvider((ref) {
  return HistoryOnOffNotifier(settings: ref.read(settingsProvider));
});

final settingsChangeProvider = StreamProvider((ref) async* {
  yield Hive.box(settingsBox).listenable();
});

class ThemeValueNotifier extends StateNotifier<ThemeData> {
  final Box<dynamic> settingsVal;
  ThemeValueNotifier(this.settingsVal)
      : super(
          ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
            useMaterial3: true,
          ),
        ) {
    init(settingsVal);
  }

  init(Box<dynamic> settingsVal) {
    if (Hive.isBoxOpen(settingsBox)) {
      debugPrint(Hive.isBoxOpen(settingsBox).toString());
      final ThemeMode themeMode = settingsVal.get(theme) ?? ThemeMode.light;
      switch (themeMode) {
        case ThemeMode.dark:
          state = ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
            useMaterial3: true,
          );
        default:
          state = ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
            useMaterial3: true,
          );
      }
    }
  }

  setDark() async {
    await settingsVal.put(theme, ThemeMode.dark);
    state = ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      useMaterial3: true,
    );
  }

  setLight() async {
    await settingsVal.put(theme, ThemeMode.light);
    state = ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      useMaterial3: true,
    );
  }
}

class HistoryOnOffNotifier extends StateNotifier<bool> {
  final Box<dynamic> _settingsBox;
  HistoryOnOffNotifier({required Box<dynamic> settings})
      : _settingsBox = settings,
        super(false) {
    init();
  }
  init() {
    state = _settingsBox.get(isHistoyOn) ?? false;
  }

  void set(bool isHis) {
    _settingsBox.put(isHistoyOn, isHis);
    state = isHis;
  }
}
