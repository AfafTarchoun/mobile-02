import 'package:medium_weather_app/constants/weather_codes.dart';

class WeatherReport {
  const WeatherReport({
    required this.current,
    required this.today,
    required this.weekly,
  });

  final CurrentWeather current;
  final List<HourlyWeather> today;
  final List<DailyWeather> weekly;

  factory WeatherReport.fromJson(Map<String, dynamic> json) {
    final current = CurrentWeather.fromJson(_map(json['current']));
    final day = current.time.length >= 10 ? current.time.substring(0, 10) : '';

    return WeatherReport(
      current: current,
      today: _hourly(_map(json['hourly']), day),
      weekly: _daily(_map(json['daily'])),
    );
  }

  static List<HourlyWeather> _hourly(Map<String, dynamic> hourly, String day) {
    final times = _strings(hourly['time']);
    final temperatures = _numbers(hourly['temperature_2m']);
    final codes = _numbers(hourly['weather_code']);
    final winds = _numbers(hourly['wind_speed_10m']);

    final entries = <HourlyWeather>[];
    for (var i = 0; i < times.length; i++) {
      if (!times[i].startsWith(day)) continue;
      entries.add(HourlyWeather(
        time: times[i],
        temperature: _at(temperatures, i),
        weatherCode: _at(codes, i).round(),
        windSpeed: _at(winds, i),
      ));
    }
    return entries;
  }

  static List<DailyWeather> _daily(Map<String, dynamic> daily) {
    final dates = _strings(daily['time']);
    final codes = _numbers(daily['weather_code']);
    final minima = _numbers(daily['temperature_2m_min']);
    final maxima = _numbers(daily['temperature_2m_max']);

    return [
      for (var i = 0; i < dates.length; i++)
        DailyWeather(
          date: dates[i],
          weatherCode: _at(codes, i).round(),
          minTemperature: _at(minima, i),
          maxTemperature: _at(maxima, i),
        ),
    ];
  }

  static Map<String, dynamic> _map(Object? value) =>
      value is Map<String, dynamic> ? value : const {};

  static List<String> _strings(Object? value) =>
      value is List ? value.map((e) => '$e').toList() : const [];

  static List<double> _numbers(Object? value) => value is List
      ? value.map((e) => e is num ? e.toDouble() : double.nan).toList()
      : const [];

  static double _at(List<double> values, int index) =>
      index < values.length ? values[index] : double.nan;
}

class CurrentWeather {
  const CurrentWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
  });

  final String time;
  final double temperature;
  final int weatherCode;
  final double windSpeed;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    final code = json['weather_code'];
    return CurrentWeather(
      time: '${json['time'] ?? ''}',
      temperature: json['temperature_2m'] is num
          ? (json['temperature_2m'] as num).toDouble()
          : double.nan,
      weatherCode: code is num ? code.round() : -1,
      windSpeed: json['wind_speed_10m'] is num
          ? (json['wind_speed_10m'] as num).toDouble()
          : double.nan,
    );
  }

  String get description => WeatherCodes.describe(weatherCode);
}

class HourlyWeather {
  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
  });

  final String time;
  final double temperature;
  final int weatherCode;
  final double windSpeed;

  String get description => WeatherCodes.describe(weatherCode);

  String get hour => time.length >= 16 ? time.substring(11, 16) : time;
}

class DailyWeather {
  const DailyWeather({
    required this.date,
    required this.weatherCode,
    required this.minTemperature,
    required this.maxTemperature,
  });

  final String date;
  final int weatherCode;
  final double minTemperature;
  final double maxTemperature;

  String get description => WeatherCodes.describe(weatherCode);
}
