import 'package:medium_weather_app/models/geo_location.dart';
import 'package:medium_weather_app/models/weather_report.dart';

class WeatherState {
  const WeatherState({
    this.location,
    this.report,
    this.errorMessage,
    this.isLoading = false,
  });

  final GeoLocation? location;
  final WeatherReport? report;
  final String? errorMessage;
  final bool isLoading;

  bool get hasError => errorMessage != null;
  bool get hasData => location != null && report != null;
}
