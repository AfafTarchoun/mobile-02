import 'package:geolocator/geolocator.dart';
import 'package:medium_weather_app/models/geo_location.dart';
import 'package:medium_weather_app/services/app_exception.dart';
import 'package:medium_weather_app/services/geocoding_service.dart';

abstract final class GeolocationService {
  static const String permissionDenied =
      'Geolocation is not available, please enable it in your App settings.';

  static const String serviceDisabled =
      'Location services are turned off on this device, please enable them or '
      'search for a city instead.';

  static const String unavailable =
      'Your position could not be determined, please search for a city '
      'instead.';

  static Future<GeoLocation> currentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const AppException(serviceDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const AppException(permissionDenied);
    }

    final Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } catch (_) {
      throw const AppException(unavailable);
    }

    return GeocodingService.reverse(position.latitude, position.longitude);
  }
}
