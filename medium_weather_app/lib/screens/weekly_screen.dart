import 'package:flutter/material.dart';
import 'package:medium_weather_app/constants/colors.dart';
import 'package:medium_weather_app/constants/weather_codes.dart';
import 'package:medium_weather_app/models/weather_state.dart';
import 'package:medium_weather_app/widgets/screen_frame.dart';

class WeeklyScreen extends StatelessWidget {
  const WeeklyScreen({super.key, required this.state});

  final WeatherState state;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Weekly',
      state: state,
      builder: (context, location, report) {
        final days = report.weekly;
        if (days.isEmpty) {
          return const Center(
            child: Text(
              'No daily data available.',
              style: TextStyle(color: AppColors.muted, fontSize: 16),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: days.length,
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.white24, height: 1),
          itemBuilder: (context, index) {
            final day = days[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(
                      day.date,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    WeatherCodes.icon(day.weatherCode),
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      day.description,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    '${day.minTemperature.round()}°C',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${day.maxTemperature.round()}°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
