import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import 'settings_provider.dart';

class WeatherState {
  final WeatherData? currentWeather;
  final List<ForecastData> forecast;
  final bool isLoading;
  final String? errorMessage;
  final String locationStatus;
  final double? lat;
  final double? lon;

  WeatherState({
    this.currentWeather,
    this.forecast = const [],
    this.isLoading = false,
    this.errorMessage,
    this.locationStatus = 'Initializing...',
    this.lat,
    this.lon,
  });

  WeatherState copyWith({
    WeatherData? currentWeather,
    List<ForecastData>? forecast,
    bool? isLoading,
    String? errorMessage,
    String? locationStatus,
    double? lat,
    double? lon,
  }) {
    return WeatherState(
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      locationStatus: locationStatus ?? this.locationStatus,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  WeatherNotifier(this.ref) : super(WeatherState()) {
    getCurrentLocation();
  }

  final Ref ref;

  Future<void> getCurrentLocation() async {
    state = state.copyWith(
      isLoading: true,
      locationStatus: 'Requesting location permissions...',
      errorMessage: null,
    );

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Please enable location services',
          locationStatus: 'Location services disabled',
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Location permissions denied',
            locationStatus: 'Permissions denied',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Permissions permanently denied',
          locationStatus: 'Permissions denied forever',
        );
        return;
      }

      state = state.copyWith(locationStatus: 'Getting your exact coordinates...');

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      state = state.copyWith(
        locationStatus: 'Fetching weather for your location...',
        lat: position.latitude,
        lon: position.longitude,
      );

      await getWeatherByCoordinates(position.latitude, position.longitude);

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error getting location: $e',
        locationStatus: 'Location error',
      );
    }
  }

  Future<void> getWeatherByCoordinates(double lat, double lon) async {
    try {
      final settings = ref.read(settingsProvider);
      String units = settings.useCelsius ? "metric" : "imperial";

      String link =
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=0e141d3690c149747eec8591200d5157&units=$units";

      final response = await http.get(Uri.parse(link));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final weather = WeatherData.fromJson(data, lat: lat, lon: lon);

        state = state.copyWith(
          currentWeather: weather,
          isLoading: false,
          locationStatus: 'Location found!',
        );

        await getForecastByCoordinates(lat, lon);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Could not get weather for your location',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error fetching weather: $e',
      );
    }
  }

  Future<void> getForecastByCoordinates(double lat, double lon) async {
    try {
      final settings = ref.read(settingsProvider);
      String units = settings.useCelsius ? "metric" : "imperial";

      String link =
          "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=0e141d3690c149747eec8591200d5157&units=$units";

      final response = await http.get(Uri.parse(link));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> forecastList = data['list'] ?? [];

        List<ForecastData> dailyForecasts = [];
        Set<String> processedDays = {};

        for (var forecast in forecastList) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
          String dayKey = "${date.year}-${date.month}-${date.day}";

          if (date.hour >= 11 && date.hour <= 13 && !processedDays.contains(dayKey)) {
            dailyForecasts.add(ForecastData.fromJson(forecast));
            processedDays.add(dayKey);
            if (dailyForecasts.length >= 5) break;
          }
        }

        state = state.copyWith(forecast: dailyForecasts);
      }
    } catch (e) {
      print("Error fetching forecast: $e");
    }
  }

  void refreshLocation() {
    getCurrentLocation();
  }
}

final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  return WeatherNotifier(ref);
});