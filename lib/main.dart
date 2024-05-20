import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/initialize_functions.dart';
import 'common/theme.dart';
import 'controller/settings_controller.dart';
import 'view/home_page.dart';

void main() async {
  await initialize();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Battles',
      themeMode: ref.watch(themeModeProvider),
      theme: ThemeDesigner.LightTheme,
      darkTheme: ThemeDesigner.DarkTheme,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
