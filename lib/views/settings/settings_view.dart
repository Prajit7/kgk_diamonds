import 'package:flutter/material.dart';
import 'package:kgk_dia/utils/custom_fonts.dart';
import '../../core/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.settingsController});

  static const String routeName = '/settings';

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          Hero(
            tag: "settings-tag",
            child: Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: SizedBox()),
          ),
          const Divider(
            height: 40,
          ),
          const Text(
            "Theme",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SegmentedButton<ThemeMode>(
            onSelectionChanged: (mode) => settingsController.updateThemeMode(
              mode.first,
            ),
            multiSelectionEnabled: false,
            emptySelectionAllowed: false,
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode_rounded),
                label: Text("Light"),
              ),
              ButtonSegment(
                icon: Icon(Icons.computer_rounded),
                value: ThemeMode.system,
                label: Text("System"),
              ),
              ButtonSegment(
                icon: Icon(Icons.dark_mode_rounded),
                value: ThemeMode.dark,
                label: Text("Dark"),
              ),
            ],
            selected: {settingsController.themeMode},
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(
            height: 40,
          ),
          const Text(
            "Font Style",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          ...List.generate(
            textThemes.length,
            (index) {
              TextTheme textTheme = textThemes.values.elementAt(index);
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  onTap: () {
                    settingsController.updateTextTheme(
                      textThemes.keys.elementAt(index),
                      textTheme,
                    );
                  },
                  title: Text(
                    textThemes.keys.elementAt(index),
                    style: textTheme.displaySmall!.copyWith(
                      color: Theme.of(context).textTheme.displaySmall!.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: settingsController.textTheme == textTheme
                      ? const Icon(
                          Icons.check_rounded,
                        )
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
