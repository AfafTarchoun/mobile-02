import 'package:flutter/material.dart';
import 'package:medium_weather_app/constants/colors.dart';
import 'package:medium_weather_app/constants/weather_codes.dart';
import 'package:medium_weather_app/models/weather_state.dart';
import 'package:medium_weather_app/widgets/screen_frame.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key, required this.state});

  final WeatherState state;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Today',
      state: state,
      builder: (context, location, report) {
        final hours = report.today;
        if (hours.isEmpty) {
          return const Center(
            child: Text(
              'No hourly data available for today.',
              style: TextStyle(color: AppColors.muted, fontSize: 16),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: hours.length,
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.white24, height: 1),
          itemBuilder: (context, index) {
            final hour = hours[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Text(
                      hour.hour,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    WeatherCodes.icon(hour.weatherCode),
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      hour.description,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    '${hour.temperature.round()}°C',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 78,
                    child: Text(
                      '${hour.windSpeed.toStringAsFixed(1)} km/h',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
