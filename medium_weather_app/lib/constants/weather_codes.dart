import 'package:flutter/material.dart';

abstract final class WeatherCodes {
  static const Map<int, String> _descriptions = {
    0: 'Clear sky',
    1: 'Mainly clear',
    2: 'Partly cloudy',
    3: 'Overcast',
    45: 'Fog',
    48: 'Depositing rime fog',
    51: 'Light drizzle',
    53: 'Moderate drizzle',
    55: 'Dense drizzle',
    56: 'Light freezing drizzle',
    57: 'Dense freezing drizzle',
    61: 'Slight rain',
    63: 'Moderate rain',
    65: 'Heavy rain',
    66: 'Light freezing rain',
    67: 'Heavy freezing rain',
    71: 'Slight snow fall',
    73: 'Moderate snow fall',
    75: 'Heavy snow fall',
    77: 'Snow grains',
    80: 'Slight rain showers',
    81: 'Moderate rain showers',
    82: 'Violent rain showers',
    85: 'Slight snow showers',
    86: 'Heavy snow showers',
    95: 'Thunderstorm',
    96: 'Thunderstorm with slight hail',
    99: 'Thunderstorm with heavy hail',
  };

  static String describe(int code) => _descriptions[code] ?? 'Unknown weather';

  static IconData icon(int code) {
    if (code == 0) return Icons.wb_sunny_outlined;
    if (code <= 2) return Icons.wb_cloudy_outlined;
    if (code == 3) return Icons.cloud_outlined;
    if (code <= 48) return Icons.foggy;
    if (code <= 57) return Icons.grain;
    if (code <= 67) return Icons.water_drop_outlined;
    if (code <= 77) return Icons.ac_unit;
    if (code <= 82) return Icons.umbrella_outlined;
    if (code <= 86) return Icons.ac_unit;
    return Icons.thunderstorm_outlined;
  }
}
