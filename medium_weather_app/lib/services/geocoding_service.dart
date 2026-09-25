import 'package:medium_weather_app/models/geo_location.dart';
import 'package:medium_weather_app/services/api_client.dart';

abstract final class GeocodingService {
  static const String notFound =
      'Could not find any result for the supplied address or coordinates.';

  static const int _suggestionCount = 5;

  static Future<List<GeoLocation>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': trimmed,
      'count': '$_suggestionCount',
      'language': 'en',
      'format': 'json',
    });

    final json = await ApiClient.getJson(uri);
    final results = json['results'];
    if (results is! List) return const [];

    return [
      for (final result in results)
        if (result is Map<String, dynamic>) GeoLocation.fromGeocoding(result),
    ];
  }

  static Future<GeoLocation> reverse(double latitude, double longitude) async {
    final uri = Uri.https('api-bdc.net', '/data/reverse-geocode-client', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'localityLanguage': 'en',
    });

    try {
      final json = await ApiClient.getJson(uri);
      final city = _firstNonEmpty([json['city'], json['locality']]);
      if (city == null) return GeoLocation.fromCoordinates(latitude, longitude);

      return GeoLocation(
        name: city,
        latitude: latitude,
        longitude: longitude,
        region: _firstNonEmpty([json['principalSubdivision']]),
        country: _firstNonEmpty([json['countryName']]),
      );
    } catch (_) {
      return GeoLocation.fromCoordinates(latitude, longitude);
    }
  }

  static String? _firstNonEmpty(List<Object?> candidates) {
    for (final candidate in candidates) {
      if (candidate is String && candidate.trim().isNotEmpty) {
        return candidate.trim();
      }
    }
    return null;
  }
}
