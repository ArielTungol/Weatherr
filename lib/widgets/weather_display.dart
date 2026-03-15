import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';

class WeatherDisplay extends ConsumerWidget {
  const WeatherDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final settings = ref.watch(settingsProvider);
    final weather = weatherState.currentWeather;

    if (weatherState.isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(),
          const SizedBox(height: 20),
          Text(
            weatherState.locationStatus,
            style: const TextStyle(color: CupertinoColors.white, fontSize: 16),
          ),
          if (weatherState.lat != null && weatherState.lon != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Lat: ${weatherState.lat!.toStringAsFixed(4)}, Lon: ${weatherState.lon!.toStringAsFixed(4)}',
                style: TextStyle(
                  color: CupertinoColors.white.withValues(alpha: 0.7), // FIXED
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    }

    if (weatherState.errorMessage != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.exclamationmark_triangle, color: CupertinoColors.white, size: 50),
          const SizedBox(height: 20),
          Text(
            weatherState.errorMessage!,
            style: const TextStyle(color: CupertinoColors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    if (weather == null) {
      return const SizedBox.shrink();
    }

    String tempSymbol = settings.useCelsius ? '°C' : '°F';
    String windUnit = settings.useCelsius ? 'm/s' : 'mph';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Text(
          weather.locationName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 28,
            color: CupertinoColors.white,
          ),
        ),
        if (weather.lat != null && weather.lon != null)
          Text(
            '${weather.lat!.toStringAsFixed(4)}°, ${weather.lon!.toStringAsFixed(4)}°',
            style: TextStyle(
              fontSize: 12,
              color: CupertinoColors.white.withValues(alpha: 0.7), // FIXED
            ),
          ),
        const SizedBox(height: 5),
        Text(
          '${weather.temperature.toStringAsFixed(0)}$tempSymbol',
          style: const TextStyle(
            fontWeight: FontWeight.w100,
            fontSize: 26,
            color: CupertinoColors.white,
          ),
        ),
        const SizedBox(height: 15),
        Icon(
          weather.weatherIcon,
          size: 60,
          color: CupertinoColors.white,
        ),
        const SizedBox(height: 10),
        Text(
          weather.weatherCondition,
          style: const TextStyle(
            fontWeight: FontWeight.w100,
            fontSize: 20,
            color: CupertinoColors.white,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Humidity: ${weather.humidity}%",
              style: const TextStyle(fontSize: 12, color: CupertinoColors.white),
            ),
            Text(
              "Wind: ${weather.windSpeed.toStringAsFixed(1)} $windUnit",
              style: const TextStyle(fontSize: 12, color: CupertinoColors.white),
            ),
          ],
        ),
      ],
    );
  }
}