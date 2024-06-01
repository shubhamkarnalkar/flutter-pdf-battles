import 'package:flutter/material.dart';

/// Custom Theme Class in order to give colors to the widgets.
class ThemeDesigner {
  // for dark theme add the properties in the copwith method
  static get DarkTheme => ThemeData.dark().copyWith(
        // primaryColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
          backgroundColor: Colors.black54,
        ),
      );

  // for light theme add the properties in the copwith method
  static get LightTheme => ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      );
}
