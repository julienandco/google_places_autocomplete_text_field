part of 'google_api_config.dart';

class Coordinates {
  /// {@macro coordinates}
  const Coordinates({required this.latitude, required this.longitude});

  /// The latitude of the coordinates.
  final double latitude;

  /// The longitude of the coordinates.
  final double longitude;
}

/// {@template location_config}
/// The configuration for the location bias or restriction of the request
/// to the Google Places API.
/// {@endtemplate}
sealed class LocationConfig {
  /// {@macro location_config}
  const LocationConfig();

  /// {@macro location_config_circle}
  /// Use this to restrict the search to a circle.
  factory LocationConfig.circle({
    required Coordinates circleCenter,
    required double circleRadiusInKilometers,
  }) => _LocationConfigCircle(
    circleCenter: circleCenter,
    circleRadius: circleRadiusInKilometers,
  );

  /// {@macro location_config_rectangle}
  /// Use this to restrict the search to a rectangle.
  factory LocationConfig.rectangle({
    required Coordinates rectangleLow,
    required Coordinates rectangleHigh,
  }) => _LocationConfigRectangle(
    rectangleLow: rectangleLow,
    rectangleHigh: rectangleHigh,
  );

  Map<String, dynamic> toJson() {
    return switch (this) {
      _LocationConfigCircle(:final circleCenter, :final circleRadius) => {
        'circle': {
          'center': {
            'latitude': circleCenter.latitude,
            'longitude': circleCenter.longitude,
          },
          'radius': circleRadius,
        },
      },
      _LocationConfigRectangle(:final rectangleLow, :final rectangleHigh) => {
        'rectangle': {
          'low': {
            'latitude': rectangleLow.latitude,
            'longitude': rectangleLow.longitude,
          },
          'high': {
            'latitude': rectangleHigh.latitude,
            'longitude': rectangleHigh.longitude,
          },
        },
      },
    };
  }
}

class _LocationConfigCircle extends LocationConfig {
  /// {@macro location_config_circle}
  const _LocationConfigCircle({
    required this.circleCenter,
    required this.circleRadius,
  }) : assert(
         circleRadius >= 0.0 && circleRadius <= 50000.0,
         'Radius must be between 0.0 and 50000.0, inclusive',
       ),
       super();

  final Coordinates circleCenter;
  final double circleRadius;
}

class _LocationConfigRectangle extends LocationConfig {
  /// {@macro location_config_rectangle}
  const _LocationConfigRectangle({
    required this.rectangleLow,
    required this.rectangleHigh,
  }) : super();

  final Coordinates rectangleLow;
  final Coordinates rectangleHigh;
}
