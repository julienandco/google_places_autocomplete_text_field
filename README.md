# google_places_autocomplete_text_field

This Flutter package helps you build a TextField that provides autocompletion suggestions from the [new Google Places API](https://developers.google.com/maps/documentation/places/web-service/op-overview).

![preview](https://github.com/julienandco/google_places_autocomplete_text_field/blob/main/preview.gif)

## Add the dependency to pubspec.yml ➕

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_places_autocomplete_text_field: <last-version>

```

## Integrate the Google AutoComplete TextField Widget in your code 🧩

```dart
    GooglePlacesAutoCompleteTextFormField(
        textEditingController: controller,
        config: const GoogleApiConfig(
          apiKey: 'YOUR_GOOGLE_API_KEY',
          // only needed if you build for the web
          proxyURL: 'https://your-proxy.com/',
          countries: ['de'], // optional, by default the list is empty (no restrictions)
          fetchPlaceDetailsWithCoordinates: true,  // if you require the coordinates from the place details
          debounceTime: 400, // defaults to 600 ms
          locationRestriction: LocationConfig.circle(
            circleCenter: const Coordinates(latitude: 52.5200, longitude: 13.4050),
            circleRadiusInKilometers: 1000,
          ), // either this or locationBias (or nothing)
          placeTypeRestriction: PlaceType.city, // if you want specific place types
        ),
        onPlaceDetailsWithCoordinatesReceived: (prediction) {
         // this method will return latlng with place detail
        print("Coordinates: (${prediction.lat},${prediction.lng})");
        }, // this callback is called when fetchCoordinates is true
        onSuggestionClicked: (prediction) {
         controller.text = prediction.description;
          controller.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description.length));
        }
    )

```

## Integrate the Google AutoComplete TextField Widget in your Web code 🌐

In case you're building for the web, you need to pass the widget a proxy URL, otherwise you will receive a CORS-Error, as there are calls to the Google Maps API being made from the frontend. If you are not Google, your domain will probably be different, thus leading to the CORS-Error. If you are Google: how ya doin 😏? I'd love to do an internship.

## Customization Option

You can customize the ```GooglePlacesAutoCompleteTextFormField``` as you would with any other ```TextFormField```.
