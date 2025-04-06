import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgk_dia/views/filters/bloc/filter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/shared_preferences_services.dart';
import 'views/cart/bloc/cart_bloc.dart';
import 'app.dart';
import 'core/settings_controller.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase, DB path, and SharedPreferences
  final futureResults = await Future.wait([
    SharedPreferences.getInstance(),
  ]);

  final sharedPreferences = futureResults[1];

  // Initialize services and controllers
  final sharedPreferencesServices =
      SharedPreferencesServices(sharedPreferences);

  final settingsController = SettingsController(
    SettingsService(sharedPreferencesServices: sharedPreferencesServices),
  );

  await settingsController.loadSettings();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(create: (_) => FilterBloc()),
      ],
      child: MyApp(settingsController: settingsController),
    ),
  );
}
