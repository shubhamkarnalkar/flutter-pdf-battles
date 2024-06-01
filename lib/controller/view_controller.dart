import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf_battles/controller/settings_controller.dart';
import '../common/constants/constants.dart';

enum UIViewTypeHistoryPage { List, Carasoul }

final UIViewProvider =
    StateNotifierProvider<UIViewNotifier, UIViewTypeHistoryPage>((ref) {
  return UIViewNotifier(settingsVal: ref.read(settingsProvider));
});

class UIViewNotifier extends StateNotifier<UIViewTypeHistoryPage> {
  final Box<dynamic> _settingsVal;
  UIViewNotifier({required Box<dynamic> settingsVal})
      : _settingsVal = settingsVal,
        super(UIViewTypeHistoryPage.Carasoul) {
    init(_settingsVal);
  }

  init(Box<dynamic> settingsVal) {
    // if (Hive.isBoxOpen(settingsBox)) {
    //   // debugPrint(Hive.isBoxOpen(settingsBox).toString());
    //   var mode = _settingsVal.get(uiView,
    //       defaultValue: UIViewTypeHistoryPage.Carasoul);
    //   setSt(mode);
    // }
  }

  setSt(UIViewTypeHistoryPage input) {
    if (input == UIViewTypeHistoryPage.Carasoul.toString()) {
      state = UIViewTypeHistoryPage.Carasoul;
    } else {
      state = UIViewTypeHistoryPage.List;
    }
  }

  setView(UIViewTypeHistoryPage inp) async {
    if (inp == UIViewTypeHistoryPage.Carasoul) {
      await _settingsVal.put(uiView, UIViewTypeHistoryPage.List.toString());
      state = UIViewTypeHistoryPage.List;
    } else {
      await _settingsVal.put(uiView, UIViewTypeHistoryPage.Carasoul.toString());
      state = UIViewTypeHistoryPage.Carasoul;
    }
  }
}
