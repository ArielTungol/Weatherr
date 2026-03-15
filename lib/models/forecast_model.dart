class ForecastData {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String weatherCondition;

  ForecastData({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.weatherCondition,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
    return ForecastData(
      date: date,
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      weatherCondition: json['weather'][0]['main'],
    );
  }

  String get dayName {
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}