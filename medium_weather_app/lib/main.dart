import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medium_weather_app/constants/colors.dart';
import 'package:medium_weather_app/models/geo_location.dart';
import 'package:medium_weather_app/models/weather_state.dart';
import 'package:medium_weather_app/screens/current_screen.dart';
import 'package:medium_weather_app/screens/today_screen.dart';
import 'package:medium_weather_app/screens/weekly_screen.dart';
import 'package:medium_weather_app/services/api_client.dart';
import 'package:medium_weather_app/services/app_exception.dart';
import 'package:medium_weather_app/services/geocoding_service.dart';
import 'package:medium_weather_app/services/geolocation_service.dart';
import 'package:medium_weather_app/services/weather_service.dart';
import 'package:medium_weather_app/widgets/bottom_bar.dart';
import 'package:medium_weather_app/widgets/search_suggestions.dart';
import 'package:medium_weather_app/widgets/top_bar.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with SingleTickerProviderStateMixin {
  static const Duration _debounceDelay = Duration(milliseconds: 300);

  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  int _tabIndex = 0;
  List<GeoLocation> _suggestions = const [];
  WeatherState _state = const WeatherState();

  int _suggestionRequest = 0;
  int _weatherRequest = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _tabIndex) {
        setState(() => _tabIndex = _tabController.index);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _onGeolocate());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() => _suggestions = const []);
      return;
    }
    _debounce = Timer(_debounceDelay, () => _loadSuggestions(query));
  }

  Future<void> _loadSuggestions(String query) async {
    final token = ++_suggestionRequest;
    try {
      final results = await GeocodingService.search(query);
      if (!mounted || token != _suggestionRequest) return;
      setState(() {
        _suggestions = results;
        if (_state.errorMessage == ApiClient.connectionFailed) {
          _state = const WeatherState();
        }
      });
    } on AppException catch (error) {
      if (!mounted || token != _suggestionRequest) return;
      setState(() {
        _suggestions = const [];
        _state = WeatherState(errorMessage: error.message);
      });
    }
  }

  void _onSubmitted(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    _loadWeather(() async {
      final results = await GeocodingService.search(trimmed);
      if (results.isEmpty) {
        throw const AppException(GeocodingService.notFound);
      }
      return results.first;
    });
  }

  void _onSuggestionSelected(GeoLocation suggestion) {
    _searchController.text = suggestion.name;
    _loadWeather(() async => suggestion);
  }

  void _onGeolocate() {
    _searchController.clear();
    _loadWeather(GeolocationService.currentLocation);
  }

  Future<void> _loadWeather(Future<GeoLocation> Function() resolve) async {
    _debounce?.cancel();
    FocusManager.instance.primaryFocus?.unfocus();

    final token = ++_weatherRequest;
    setState(() {
      _suggestions = const [];
      _state = const WeatherState(isLoading: true);
    });

    try {
      final location = await resolve();
      final report = await WeatherService.fetch(location);
      if (!mounted || token != _weatherRequest) return;
      setState(() => _state = WeatherState(location: location, report: report));
    } on AppException catch (error) {
      if (!mounted || token != _weatherRequest) return;
      setState(() => _state = WeatherState(errorMessage: error.message));
    } catch (_) {
      if (!mounted || token != _weatherRequest) return;
      setState(() {
        _state = const WeatherState(errorMessage: ApiClient.connectionFailed);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.background,
        appBar: TopBar(
          controller: _searchController,
          onChanged: _onQueryChanged,
          onSubmitted: _onSubmitted,
          onGeolocate: _onGeolocate,
          isLoading: _state.isLoading,
        ),
        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                CurrentScreen(state: _state),
                TodayScreen(state: _state),
                WeeklyScreen(state: _state),
              ],
            ),
            if (_suggestions.isNotEmpty)
              SearchSuggestions(
                suggestions: _suggestions,
                onSelected: _onSuggestionSelected,
                onDismiss: () => setState(() => _suggestions = const []),
              ),
          ],
        ),
        bottomNavigationBar: BottomBar(
          onItemSelected: _tabController.animateTo,
          currentIndex: _tabIndex,
        ),
      ),
    );
  }
}
