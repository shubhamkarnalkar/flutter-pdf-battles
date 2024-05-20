import 'package:flutter/material.dart';

/// Custom Theme Class in order to give colors to the widgets.
class ThemeDesigner {
  // for dark theme add the properties in the copwith method
  static get DarkTheme => ThemeData.dark().copyWith(
        useMaterial3: true,
        primaryColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
          backgroundColor: Colors.black54,
        ),
        // switchTheme: SwitchThemeData().copyWith(
        //   thumbColor: MaterialStatePropertyAll(Colors.black),
        //   trackColor: MaterialStatePropertyAll(Colors.grey),
        // ),
      );

  // for light theme add the properties in the copwith method
  static get LightTheme => ThemeData.light().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      );
}
