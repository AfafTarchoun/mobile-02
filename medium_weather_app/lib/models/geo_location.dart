class GeoLocation {
  const GeoLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.region,
    this.country,
  });

  final String name;
  final double latitude;
  final double longitude;
  final String? region;
  final String? country;

  factory GeoLocation.fromGeocoding(Map<String, dynamic> json) {
    return GeoLocation(
      name: _text(json['name']) ?? 'Unknown place',
      latitude: _number(json['latitude']),
      longitude: _number(json['longitude']),
      region: _text(json['admin1']),
      country: _text(json['country']),
    );
  }

  factory GeoLocation.fromCoordinates(double latitude, double longitude) {
    return GeoLocation(
      name: _formatCoordinates(latitude, longitude),
      latitude: latitude,
      longitude: longitude,
    );
  }

  String get subtitle => [region, country]
      .whereType<String>()
      .where((part) => part.isNotEmpty)
      .join(', ');

  String get fullName {
    final rest = subtitle;
    return rest.isEmpty ? name : '$name, $rest';
  }

  String get coordinates => _formatCoordinates(latitude, longitude);

  static String _formatCoordinates(double latitude, double longitude) =>
      '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';

  static String? _text(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static double _number(Object? value) =>
      value is num ? value.toDouble() : double.nan;
}
