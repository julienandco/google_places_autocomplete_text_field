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
        proxyURL: "https://your-proxy.com/", // only needed if you build for the web
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

## Integrate the Google AutoComplete TextField Widget in your Web code 🌐

In case you're building for the web, you need to pass the widget a proxy URL, otherwise you will receive a CORS-Error, as there are calls to the Google Maps API being made from the frontend. If you are not Google, your domain will probably be different, thus leading to the CORS-Error. If you are Google: how ya doin 😏? I'd love to do an internship.

## Customization Option

You can customize the ```GooglePlacesAutoCompleteTextFormField``` as you would with any other ```TextFormField```.
