import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf_battles/common/constants/constants.dart';

final settingsProvider = Provider((ref) {
  return Hive.box(settingsBox);
});

final themeModeProvider =
    StateNotifierProvider<ThemeValueNotifier, ThemeMode>((ref) {
  return ThemeValueNotifier(ref.read(settingsProvider));
});

final historyOnOffProvider =
    StateNotifierProvider<HistoryOnOffNotifier, bool>((ref) {
  return HistoryOnOffNotifier(settings: ref.read(settingsProvider));
});

final settingsChangeProvider = StreamProvider((ref) async* {
  yield Hive.box(settingsBox).listenable();
});

class ThemeValueNotifier extends StateNotifier<ThemeMode> {
  final Box<dynamic> settingsVal;
  ThemeValueNotifier(this.settingsVal) : super(ThemeMode.light) {
    init(settingsVal);
  }

  init(Box<dynamic> settingsVal) {
    if (Hive.isBoxOpen(settingsBox)) {
      // debugPrint(Hive.isBoxOpen(settingsBox).toString());
      var themeMode = settingsVal.get(themeWord, defaultValue: ThemeMode.light);
      if (themeMode == ThemeMode.dark.toString()) {
        state = ThemeMode.dark;
      } else {
        state = ThemeMode.light;
      }
    }
  }

  setDark() async {
    await settingsVal.put(themeWord, ThemeMode.dark.toString());
    state = ThemeMode.dark;
  }

  setLight() async {
    await settingsVal.put(themeWord, ThemeMode.light.toString());
    state = ThemeMode.light;
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
    var _val = _settingsBox.get(isHistoyOn, defaultValue: false);
    if (_val == true.toString()) {
      state = true;
    } else {
      state = false;
    }
  }

  void set(bool isHis) {
    _settingsBox.put(isHistoyOn, isHis.toString());
    state = isHis;
  }
}
