import 'package:flutter_test/flutter_test.dart';
import 'package:medium_weather_app/main.dart';
import 'package:medium_weather_app/models/weather_report.dart';

void main() {
  testWidgets('starts on the Current tab with the search bar ready',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Search location...'), findsOneWidget);
    expect(find.text('Current'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Weekly'), findsOneWidget);
  });

  test('keeps only the current day in the hourly series', () {
    final report = WeatherReport.fromJson(const {
      'current': {
        'time': '2026-09-22T20:15',
        'temperature_2m': 22.3,
        'weather_code': 0,
        'wind_speed_10m': 8.8,
      },
      'hourly': {
        'time': ['2026-09-22T00:00', '2026-09-22T01:00', '2026-09-23T00:00'],
        'temperature_2m': [15.0, 14.5, 16.0],
        'weather_code': [0, 3, 61],
        'wind_speed_10m': [5.0, 6.0, 7.0],
      },
      'daily': {
        'time': ['2026-09-22', '2026-09-23'],
        'weather_code': [0, 61],
        'temperature_2m_max': [24.0, 21.0],
        'temperature_2m_min': [12.0, 11.0],
      },
    });

    expect(report.today.length, 2);
    expect(report.today.first.hour, '00:00');
    expect(report.current.description, 'Clear sky');
    expect(report.weekly.length, 2);
    expect(report.weekly.last.description, 'Slight rain');
  });
}
