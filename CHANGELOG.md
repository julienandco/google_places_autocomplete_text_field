# Changelog 🪵

## 1.1.0

* [Docs]: Add documentation for undocumented class members (thank you [@Pietrucci-Blacher](https://github.com/Pietrucci-Blacher)!)
* [Fix]: Handle unhandled exception when widget is disposed (thanks for finding this bug [@jsanders5](https://github.com/jsanders5)!)
* [Fix]: Improve the error handling in the API class (thank you [@Alienjob](https://github.com/Alienjob)!)
* [Feat]: Add language code functionality to receive API answers in the specified language (thank you [@raulgarciaalcaraz-zero](https://github.com/raulgarciaalcaraz-zero)!)

## 1.0.0

All the changes marked with (*) are the work of [@lucaantonelli](https://github.com/lucaantonelli), thank you a lot!

* [Breaking]: Implement new Places API (*)
* [Add]: Add a minimum input length (*)
* [Add]: Add the possibility to use a session token (thanks for the first implementation [@lucaantonelli](https://github.com/lucaantonelli)!)
* [Add]: Add the `maxHeight` parameter to manipulate the overlay height (special thanks to [@Muhammed-Ayad](https://github.com/Muhammed-Ayad)!)
* [Chore]: Remove unused `toJson` methods from several classes
* [Chore]: Added doc comments to `GooglePlacesAutoCompleteTextFormField`
* [Breaking]: Rename `itmClick` to `onSuggestionClicked`
* [Breaking]: Rename `isLatLngRequired` to `fetchCoordinates`
* [Breaking]: Rename `overlayContainer` to `overlayContainerBuilder`
* [Breaking]: Remove unnecessary typedefs: `GetPlaceDetailswWithLatLng`, `ItemClick` and `OverlayContainer`
* [Fix]: Make the `TextEditingController` nullable and ensure the `initialValue` property can be used (thanks for finding this bug [@trusilosv](https://github.com/trusilosv)!)
* [Add]: Add the `fetchSuggestionsForInitialValue` parameter to instantly fetch suggestions when an initial value is given.
* [Refactor]: Extract the Google Places API logic into an own class
* [Fix]: Make sure the overlay adapts to multiline input (thanks for finding this bug [@iamdiogo](https://github.com/iamdiogo)!)
* [Breaking]: Rename `getPlaceDetailWithLatLng`to `onPlaceDetailsWithCoordinatesReceived`

## 0.1.3

* [Fix]: Removed the duplicate declaration of the fields `inputDecoration` and `decoration`, which were misleading. Now only the field `decoration` is available to assign a `InputDecoration`  to the `GooglePlacesAutoCompleteTextFormField`, following the `TextFormField` convention.

## 0.1.2

* [Add]: New argument `validator` now you can validate the field if it's used inside the Form widget. More information is available in the example.
* [Update]: Example updated.

## 0.1.1

* [Fix]: Fixed a bug where the Google API Url would not be correctly built if no proxy URL was provided.

## 0.1.0

* [Add]: Added compatibility for Flutter Web 🌐. Just pass the `GooglePlacesAutoCompleteTextFormField` a proxy URL and you're good to go!

## 0.0.3

* [Fix]: Fixed a bug on MacOS where clicking on the predictions would not be registered.

## 0.0.2

* [Add]: New argument `overlayContainer` so that you can now fully customize the appearance of the predictions as well!
* [Fix]: Fixed a bug where the overlay with the predictions would not be closed as soon as the focus is lost.

## 0.0.1

* Initial release of a fully customizable `TextFormField` that sends your input to the Google Places API and provides you with suggestions for autocompletion.
