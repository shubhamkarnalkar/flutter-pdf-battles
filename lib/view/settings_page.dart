import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_battles/controller/settings_controller.dart';

import '../common/constants/providers.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  void setHistoryValue(bool val) {
    ref.read(historyOnOffProvider.notifier).set(val);
  }

  void setDarkModeValue(bool valDark) {
    if (valDark) {
      ref.read(themeModeProvider.notifier).setDark();
    } else {
      ref.read(themeModeProvider.notifier).setLight();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool _isHistoryOn = identical(ref.watch(historyOnOffProvider), true);
    final bool _isDark =
        identical(ref.watch(themeModeProvider), ThemeMode.dark);
    final packageInfo = ref.watch(packageInfoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SwitchListTile(
              value: _isHistoryOn,
              title: const Text("History"),
              onChanged: setHistoryValue,
            ),
            SwitchListTile(
              value: _isDark,
              title: const Text("Dark Mode"),
              onChanged: setDarkModeValue,
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: packageInfo.when(
                data: (data) => Text('version: ${data.version}'),
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => CircularProgressIndicator.adaptive(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
