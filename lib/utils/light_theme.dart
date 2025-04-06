import 'package:flutter/material.dart';
import 'package:kgk_dia/core/settings_controller.dart';

ThemeData lightThemeData(SettingsController settingsController) => ThemeData(
      textTheme: settingsController.textTheme,
    );
