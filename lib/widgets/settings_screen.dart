import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../providers/weather_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final weatherState = ref.watch(weatherProvider);

    return CupertinoPageScaffold(
      child: ListView(
        children: [
          CupertinoListSection.insetGrouped(
            children: [
              CupertinoListTile(
                leading: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: CupertinoColors.systemBlue,
                  ),
                  child: const Icon(
                    CupertinoIcons.moon_fill,
                    size: 20,
                    color: CupertinoColors.white,
                  ),
                ),
                title: const Text("Dark Mode"),
                trailing: CupertinoSwitch(
                  value: settings.darkMode,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).toggleDarkMode();
                  },
                ),
              ),
              CupertinoListTile(
                leading: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: CupertinoColors.systemOrange,
                  ),
                  child: const Icon(
                    CupertinoIcons.refresh,
                    size: 20,
                    color: CupertinoColors.white,
                  ),
                ),
                title: const Text("Refresh My Location"),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.refresh),
                  onPressed: () {
                    ref.read(weatherProvider.notifier).refreshLocation();
                  },
                ),
              ),
              CupertinoListTile(
                leading: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: CupertinoColors.systemPurple,
                  ),
                  child: const Icon(
                    CupertinoIcons.thermometer,
                    size: 20,
                    color: CupertinoColors.white,
                  ),
                ),
                title: const Text("Temperature Unit"),
                trailing: CupertinoSwitch(
                  value: settings.useCelsius,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).toggleTemperature();
                    if (weatherState.lat != null && weatherState.lon != null) {
                      ref.read(weatherProvider.notifier).getWeatherByCoordinates(
                        weatherState.lat!,
                        weatherState.lon!,
                      );
                    }
                  },
                  activeColor: CupertinoColors.systemBlue,
                ),
              ),
            ],
          ),
          if (weatherState.lat != null && weatherState.lon != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Your exact coordinates:\n${weatherState.lat!.toStringAsFixed(6)}, ${weatherState.lon!.toStringAsFixed(6)}",
                style: const TextStyle(
                  fontSize: 10,
                  color: CupertinoColors.systemGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}