import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import 'weather_display.dart';
import 'forecast_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final settings = ref.watch(settingsProvider);

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          // Background GIF
          Positioned.fill(
            child: Image.network(
              weatherState.currentWeather?.gifUrl ??
                  "https://i.giphy.com/media/l0HlN8tXWjUvK4uKs/giphy.gif",
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(color: CupertinoColors.systemGrey);
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: CupertinoColors.systemGrey,
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.exclamationmark_triangle,
                      color: CupertinoColors.white,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
          ),

          // Overlay
          Positioned.fill(
            child: Container(
              color: CupertinoColors.black.withOpacity(0.4),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const WeatherDisplay(),
                const SizedBox(height: 25),
                if (!weatherState.isLoading && weatherState.currentWeather != null)
                  const ForecastWidget(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}