import 'package:medium_weather_app/models/geo_location.dart';
import 'package:medium_weather_app/models/weather_report.dart';
import 'package:medium_weather_app/services/api_client.dart';

abstract final class WeatherService {
  static const int _forecastDays = 7;

  static Future<WeatherReport> fetch(GeoLocation location) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${location.latitude}',
      'longitude': '${location.longitude}',
      'current': 'temperature_2m,weather_code,wind_speed_10m',
      'hourly': 'temperature_2m,weather_code,wind_speed_10m',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
      'timezone': 'auto',
      'forecast_days': '$_forecastDays',
    });

    return WeatherReport.fromJson(await ApiClient.getJson(uri));
  }
}
