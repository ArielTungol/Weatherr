import 'package:flutter/cupertino.dart';

class WeatherData {
  final String locationName;
  final double temperature;
  final String weatherCondition;
  final int humidity;
  final double windSpeed;
  final IconData weatherIcon;
  final String gifUrl;
  final double? lat;
  final double? lon;

  WeatherData({
    required this.locationName,
    required this.temperature,
    required this.weatherCondition,
    required this.humidity,
    required this.windSpeed,
    required this.weatherIcon,
    required this.gifUrl,
    this.lat,
    this.lon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json, {double? lat, double? lon}) {
    String condition = json["weather"][0]["main"];

    return WeatherData(
      locationName: json["name"]?.toString() ?? "Your Location",
      temperature: (json["main"]["temp"] as num).toDouble(),
      weatherCondition: condition,
      humidity: json["main"]["humidity"],
      windSpeed: (json["wind"]["speed"] as num).toDouble(),
      weatherIcon: _getWeatherIcon(condition),
      gifUrl: _getWeatherGif(condition),
      lat: lat,
      lon: lon,
    );
  }

  static IconData _getWeatherIcon(String condition) {
    switch (condition) {
      case "Clouds":
        return CupertinoIcons.cloud;
      case "Rain":
        return CupertinoIcons.cloud_drizzle;
      case "Clear":
        return CupertinoIcons.sun_max;
      case "Snow":
        return CupertinoIcons.snow;
      case "Thunderstorm":
        return CupertinoIcons.cloud_bolt;
      case "Drizzle":
        return CupertinoIcons.cloud_drizzle_fill;
      case "Mist":
      case "Fog":
      case "Haze":
        return CupertinoIcons.cloud_fog;
      default:
        return CupertinoIcons.cloud;
    }
  }

  static String _getWeatherGif(String condition) {
    switch (condition) {
      case "Clouds":
        return "https://media0.giphy.com/media/v1.Y2lkPTZjMDliOTUyZGtya2o2Nzh2NnAzbmsxOWV4MXgwMXRxNHhibHkydWQycXczNnU0ZiZlcD12MV9naWZzX3NlYXJjaCZjdT1n/0Styincf6K2tvfjb5Q/200w.gif";
      case "Rain":
        return "https://media3.giphy.com/media/tnPxFTth7qoDiw1rnm/giphy.gif";
      case "Clear":
        return "https://media.tenor.com/yw1DWqXPXHAAAAAM/what-a-sunny-day.gif";
      case "Snow":
        return "https://media.tenor.com/3RDSUDifYtQAAAAM/snowing.gif";
      case "Thunderstorm":
        return "https://media.tenor.com/uToSLPDUN44AAAAM/lightning-nature.gif";
      case "Drizzle":
        return "https://64.media.tumblr.com/8701186168513af2fe1054bf8c230fef/tumblr_nsm2v5xGaq1uckjo7o1_540.gif";
      case "Mist":
      case "Fog":
      case "Haze":
        return "https://www.sandcem.com/uploads/1/4/5/6/14568844/3687085_orig.gif";
      default:
        return "https://i.giphy.com/media/l0HlN8tXWjUvK4uKs/giphy.gif";
    }
  }
}