class FieldMask {
  static String get defaultSuggestionsFieldMask => [
    'suggestions.placePrediction.placeId',
    'suggestions.placePrediction.text',
    'suggestions.placePrediction.structuredFormat',
    'suggestions.placePrediction.types',
  ].join(',');

  static String get defaultPlaceDetailsFieldMask => [
    'id',
    'addressComponents',
    'adrFormatAddress',
    'formattedAddress',
    'iconMaskBaseUri',
    'name',
    'location',
    'photos',
    'types',
    'googleMapsUri',
    'utcOffsetMinutes',
    'websiteUri',
  ].join(',');
}
