import 'package:flutter/material.dart';
import 'package:medium_weather_app/constants/colors.dart';
import 'package:medium_weather_app/constants/weather_codes.dart';
import 'package:medium_weather_app/models/weather_state.dart';
import 'package:medium_weather_app/widgets/screen_frame.dart';

class CurrentScreen extends StatelessWidget {
  const CurrentScreen({super.key, required this.state});

  final WeatherState state;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: 'Current',
      state: state,
      builder: (context, location, report) {
        final current = report.current;
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${current.temperature.round()}°C',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 64,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 12),
              Icon(
                WeatherCodes.icon(current.weatherCode),
                color: Colors.white,
                size: 56,
              ),
              const SizedBox(height: 12),
              Text(
                current.description,
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.air, color: AppColors.muted),
                  const SizedBox(width: 8),
                  Text(
                    '${current.windSpeed.toStringAsFixed(1)} km/h',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
