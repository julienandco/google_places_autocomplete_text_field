import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/src/model/field_mask.dart';

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

  Map<String, dynamic> _buildRequestHeaders({
    required GoogleApiConfig config,
    required String fieldMask,
  }) {
    return {
      'X-Goog-Api-Key': config.apiKey,
      'X-Goog-FieldMask': fieldMask,
      if (config.packageName != null) 'X-Android-Package': config.packageName,
      if (config.sha1 != null) 'X-Android-Cert': config.sha1,
      if (config.iosBundleId != null)
        'X-Ios-Bundle-Identifier': config.iosBundleId,
    };
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
    }
    if (config.languageCode != null) {
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

    final headers = _buildRequestHeaders(
      config: config,
      fieldMask:
          config.suggestionsFieldMask ?? FieldMask.defaultSuggestionsFieldMask,
    );

    Options options = Options(headers: headers);

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
      final fieldMask =
          config.placeDetailsFieldMask ??
          FieldMask.defaultPlaceDetailsFieldMask;

      final url = _buildRequestUrl(
        proxyUrl: config.proxyURL,
        appendix: '/${prediction.placeId}',
      );

      final sessionToken = config.sessionToken;

      final response = await _dio.get(
        url,
        queryParameters: {
          if (sessionToken != null) 'sessionToken': sessionToken,
        },
        options: Options(
          headers: _buildRequestHeaders(config: config, fieldMask: fieldMask),
        ),
      );

      final result = PlaceDetails.fromJson(response.data).result;

      final location = result?.geometry?.location;
      if (location?.lat != null && location?.lng != null) {
        prediction.lat = location!.lat.toString();
        prediction.lng = location.lng.toString();
      }

      prediction.formattedAddress = result?.formattedAddress;
      prediction.addressComponents = result?.addressComponents;

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
