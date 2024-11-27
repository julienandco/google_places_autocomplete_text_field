import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/src/model/place_details.dart';
import 'package:google_places_autocomplete_text_field/src/model/prediction.dart';

/// {@template google_places_api}
/// Interface for Google Places API.
/// {@endtemplate}
class GooglePlacesApi {
  /// {@macro google_places_api}
  GooglePlacesApi() : _dio = Dio();

  /// The [Dio] instance used to make HTTP requests.
  final Dio _dio;

  /// The API URL for the Google Places API.
  final _apiUrl = 'https://places.googleapis.com/v1/places';

  /// Fetches suggestions for the given [input] with the provided
  /// [googleAPIKey].
  Future<PlacesAutocompleteResponse?> getSuggestionsForInput({
    required String input,
    required String googleAPIKey,
    List<String> countries = const [],
    String? sessionToken,
    String proxyUrl = '',
  }) async {
    final prefix = proxyUrl;

    String url = "$prefix$_apiUrl:autocomplete";

    Map<String, dynamic> requestBody = {
      "input": input,
    };

    if (countries.isNotEmpty) {
      requestBody["includedRegionCodes"] = countries;
    }
    if (sessionToken != null) {
      requestBody["sessionToken"] = sessionToken;
    }
    Options options = Options(
      headers: {"X-Goog-Api-Key": googleAPIKey},
    );

    try {
      final response =
          await _dio.post(url, options: options, data: jsonEncode(requestBody));
      final subscriptionResponse =
          PlacesAutocompleteResponse.fromJson(response.data);
      return subscriptionResponse;
    } catch (e) {
      debugPrint('GooglePlacesApi.getSuggestionsForInput: ${e.toString()}');
      return null;
    }
  }

  /// Fetches the place details for the given [prediction] with the provided
  /// [googleAPIKey].
  Future<Prediction?> fetchCoordinatesForPrediction({
    required Prediction prediction,
    required String googleAPIKey,
    String proxyUrl = '',
    String? sessionToken,
  }) async {
    try {
      final prefix = proxyUrl;

      String url =
          "$prefix$_apiUrl/${prediction.placeId}?fields=*&key=$googleAPIKey";
      if (sessionToken != null) {
        url += "&sessionToken=$sessionToken";
      }
      final response = await _dio.get(url);

      final placeDetails = PlaceDetails.fromJson(response.data);

      prediction.lat = placeDetails.result!.geometry!.location!.lat.toString();
      prediction.lng = placeDetails.result!.geometry!.location!.lng.toString();

      return prediction;
    } catch (e) {
      debugPrint(
          'GooglePlacesApi.fetchCoordinatesForPrediction: ${e.toString()}');
      return null;
    }
  }
}
