import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/forecast_model.dart'; // ADD THIS IMPORT
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';

class ForecastWidget extends ConsumerWidget {
  const ForecastWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final settings = ref.watch(settingsProvider);
    final forecast = weatherState.forecast;
    final tempSymbol = settings.useCelsius ? '°C' : '°F';

    if (forecast.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: CupertinoColors.black.withValues(alpha: 0.3), // FIXED: use withValues
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.white.withValues(alpha: 0.2), // FIXED: use withValues
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "5-DAY FORECAST",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...forecast.map((f) => _buildForecastRow(f, tempSymbol)), // FIXED: removed .toList()
        ],
      ),
    );
  }

  Widget _buildForecastRow(ForecastData forecast, String tempSymbol) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.white.withValues(alpha: 0.2), // FIXED: use withValues
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            forecast.dayName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.white,
            ),
          ),
          Row(
            children: [
              Text(
                '${forecast.tempMin.toStringAsFixed(0)}$tempSymbol',
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.white.withValues(alpha: 0.7), // FIXED: use withValues
                ),
              ),
              const SizedBox(width: 15),
              Text(
                '${forecast.tempMax.toStringAsFixed(0)}$tempSymbol',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}