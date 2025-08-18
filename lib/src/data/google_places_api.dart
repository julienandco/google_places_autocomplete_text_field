import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';

/// {@template places_api}
/// Interface for Places Autocomplete requests.
/// {@endtemplate}
abstract class PlacesApi {
  /// Fetches suggestions for the given input with the provided
  /// [GoogleApiConfig].
  Future<PlacesAutocompleteResponse?> getSuggestionsForInput({
    required String input,
    required GoogleApiConfig config,
  });

  /// Fetches the place details for the given [Prediction] with the provided
  /// [GoogleApiConfig].
  Future<Prediction?> fetchCoordinatesForPrediction({
    required Prediction prediction,
    required GoogleApiConfig config,
  });
}

/// {@template google_places_api}
/// Interface for Google Places API.
/// {@endtemplate}
class GooglePlacesApi implements PlacesApi {
  /// {@macro google_places_api}
  GooglePlacesApi() : _dio = Dio();

  /// The [Dio] instance used to make HTTP requests.
  final Dio _dio;

  /// The API URL for the Google Places API.
  final _apiUrl = 'places.googleapis.com/v1/places';

  String _buildRequestUrl({required String appendix, String? proxyUrl}) {
    final prefix = proxyUrl ?? 'https://';
    final url = '$prefix$_apiUrl$appendix';
    return url;
  }

  @override
  Future<PlacesAutocompleteResponse?> getSuggestionsForInput({
    required String input,
    required GoogleApiConfig config,
  }) async {
    final url = _buildRequestUrl(
      proxyUrl: config.proxyURL,
      appendix: ':autocomplete',
    );

    Map<String, dynamic> requestBody = {'input': input};

    if (config.countries.isNotEmpty) {
      requestBody['includedRegionCodes'] = config.countries;
      requestBody['languageCode'] = config.languageCode;
    }
    if (config.sessionToken != null) {
      requestBody['sessionToken'] = config.sessionToken;
    }

    // Only one of locationRestriction or locationBias can be provided,
    // so we prefer restriction over bias, as it is more exclusive.
    if (config.locationRestriction != null) {
      requestBody['locationRestriction'] = config.locationRestriction?.toJson();
    } else if (config.locationBias != null) {
      requestBody['locationBias'] = config.locationBias?.toJson();
    }

    if (config.placeTypeRestriction != null) {
      requestBody['includedPrimaryTypes'] =
          config.placeTypeRestriction!.toJson();
    }

    Options options = Options(
      headers: {'X-Goog-Api-Key': config.apiKey, 'X-Goog-FieldMask': '*'},
    );

    try {
      final response = await _dio.post(
        url,
        options: options,
        data: jsonEncode(requestBody),
      );
      final subscriptionResponse = PlacesAutocompleteResponse.fromJson(
        response.data,
      );
      return subscriptionResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(
          'GooglePlacesApi.getSuggestionsForInput: DioException [${e.type}]: ${e.message}',
        );
        debugPrint('Response data: ${e.response?.data}');
      } else {
        debugPrint(
          'GooglePlacesApi.getSuggestionsForInput: DioException [${e.type}]: ${e.message}',
        );
      }
      return null;
    } catch (e) {
      debugPrint('GooglePlacesApi.getSuggestionsForInput: ${e.toString()}');
      return null;
    }
  }

  @override
  Future<Prediction?> fetchCoordinatesForPrediction({
    required Prediction prediction,
    required GoogleApiConfig config,
  }) async {
    try {
      String url = _buildRequestUrl(
        proxyUrl: config.proxyURL,
        appendix: '/${prediction.placeId}?fields=*&key=${config.apiKey}',
      );

      final sessionToken = config.sessionToken;
      if (sessionToken != null) {
        url += '&sessionToken=$sessionToken';
      }
      final response = await _dio.get(url);

      final placeDetails = PlaceDetails.fromJson(response.data);

      prediction.lat = placeDetails.result!.geometry!.location!.lat.toString();
      prediction.lng = placeDetails.result!.geometry!.location!.lng.toString();

      return prediction;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(
          'GooglePlacesApi.fetchCoordinatesForPrediction: DioException [${e.type}]: ${e.message}',
        );
        debugPrint('Response data: ${e.response?.data}');
      } else {
        debugPrint(
          'GooglePlacesApi.fetchCoordinatesForPrediction: DioException [${e.type}]: ${e.message}',
        );
      }
      return null;
    } catch (e) {
      debugPrint(
        'GooglePlacesApi.fetchCoordinatesForPrediction: ${e.toString()}',
      );
      return null;
    }
  }
}
