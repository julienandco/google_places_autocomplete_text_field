part 'location_config.dart';

/// {@template google_api_config}
/// The configuration for the Google API to be used during any request.
/// {@endtemplate}
class GoogleApiConfig {
  /// {@macro google_api_config}
  const GoogleApiConfig({
    required this.apiKey,
    this.proxyURL,
    this.sessionToken,
    this.countries = const [],
    this.languageCode,
    this.debounceTime = 600,
    this.fetchPlaceDetailsWithCoordinates = false,
    this.locationBias,
    this.locationRestriction,
  }) : assert(
         (locationBias == null || locationRestriction == null),
         'Only one of locationBias or locationRestriction can be provided',
       );

  /// The Google API key that is used to authenticate the requests to the
  /// Google Places API.
  final String apiKey;

  /// The URL of the proxy server that is used to send the requests to the
  /// Google Places API. If this is null, the requests will be sent directly to
  /// the Google Places API.
  final String? proxyURL;

  /// The session token to be used for the requests to the Google
  /// Places API.
  final String? sessionToken;

  /// The list of countries that the suggestions should be limited to. If this
  /// is empty, the suggestions will not be limited to any country.
  final List<String> countries;

  /// The language code that is used to fetch the suggestions. If this is null,
  /// the default language code of the device will be used.
  final String? languageCode;

  /// The time in milliseconds that the widget waits before sending a request
  /// to the Google Places API. This is used to prevent too many requests from
  /// being sent.
  final int debounceTime;

  /// Whether the coordinate fetch should be performed for the selected place.
  /// If set to false, place details are returned without coordinate
  /// information.
  final bool fetchPlaceDetailsWithCoordinates;

  /// Configuration for the location restriction of the request
  /// to the Google Places API.
  /// For more info, refer to Google's docs: https://developers.google.com/maps/documentation/places/web-service/place-autocomplete#location-bias-restriction
  final LocationConfig? locationRestriction;

  /// Configuration for the location bias of the request
  /// to the Google Places API.
  /// For more info, refer to Google's docs: https://developers.google.com/maps/documentation/places/web-service/place-autocomplete#location-bias-restriction
  final LocationConfig? locationBias;
}
