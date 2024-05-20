import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_battles/controller/settings_controller.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  void setHistoryValue(bool val) {
    if (val) {
    } else {}
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
    final bool isDark = identical(ref.watch(themeModeProvider), ThemeMode.dark);
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
              value: false,
              title: const Text("History"),
              onChanged: setHistoryValue,
            ),
            SwitchListTile(
              value: isDark,
              title: const Text("Dark Mode"),
              onChanged: setDarkModeValue,
            ),
          ],
        ),
      ),
    );
  }
}
