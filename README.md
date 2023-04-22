# google_places_autocomplete_text_field

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
        googleAPIKey: "YOUR_GOOGLE_API_KEY",
        debounceTime: 400 // defaults to 600 ms,
        countries: ["de"], // optional, by default the list is empty (no restrictions)
        isLatLngRequired: true, // if you require the coordinates from the place details
        getPlaceDetailWithLatLng: (prediction) {
         // this method will return latlng with place detail
        print("placeDetails" + prediction.lng.toString());
        }, // this callback is called when isLatLngRequired is true
        itmClick: (prediction) {
         controller.text = prediction.description;
          controller.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description.length));
        }
    )

```

## Customization Option

You can customize the ```GooglePlacesAutoCompleteTextFormField``` as you would with any other ```TextFormField```.
