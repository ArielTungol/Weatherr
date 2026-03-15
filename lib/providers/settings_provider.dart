import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final bool useCelsius;
  final bool darkMode;

  SettingsState({
    this.useCelsius = true,
    this.darkMode = true,
  });

  SettingsState copyWith({
    bool? useCelsius,
    bool? darkMode,
  }) {
    return SettingsState(
      useCelsius: useCelsius ?? this.useCelsius,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState());

  void toggleTemperature() {
    state = state.copyWith(useCelsius: !state.useCelsius);
  }

  void toggleDarkMode() {
    state = state.copyWith(darkMode: !state.darkMode);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});