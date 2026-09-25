import 'package:flutter/material.dart';
import 'package:medium_weather_app/constants/colors.dart';
import 'package:medium_weather_app/models/geo_location.dart';
import 'package:medium_weather_app/models/weather_report.dart';
import 'package:medium_weather_app/models/weather_state.dart';
import 'package:medium_weather_app/widgets/error_view.dart';

class ScreenFrame extends StatelessWidget {
  const ScreenFrame({
    super.key,
    required this.title,
    required this.state,
    required this.builder,
  });

  final String title;
  final WeatherState state;
  final Widget Function(BuildContext, GeoLocation, WeatherReport) builder;

  @override
  Widget build(BuildContext context) {
    if (state.hasError) return ErrorView(message: state.errorMessage!);
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (!state.hasData) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Search for a city or use the geolocation button to get the '
            'weather.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 18),
          ),
        ),
      );
    }

    final location = state.location!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(title: title, location: location),
        Expanded(child: builder(context, location, state.report!)),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.location});

  final String title;
  final GeoLocation location;

  @override
  Widget build(BuildContext context) {
    final subtitle = location.subtitle;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.faded, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            location.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 16),
            ),
          const SizedBox(height: 2),
          Text(
            location.coordinates,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.faded, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
