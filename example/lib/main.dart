import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Places Autocomplete Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Google Places Autocomplete Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _config = GoogleApiConfig(
    apiKey: 'foo-bar',
    locationRestriction: LocationConfig.circle(
      circleCenter: const Coordinates(latitude: 52.5200, longitude: 13.4050),
      circleRadiusInKilometers: 1000,
    ),
    // only needed if you build for the web
    proxyURL: 'https://your-proxy.com/',
    placeTypeRestriction: PlaceType.city,
  );

  final _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: GooglePlacesAutoCompleteTextFormField(
                config: _config,
                textEditingController: _textController,
                decoration: const InputDecoration(
                  hintText: 'Enter your address',
                  labelText: 'Address',
                  labelStyle: TextStyle(color: Colors.purple),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                // proxyURL: _yourProxyURL,
                maxLines: 1,
                overlayContainerBuilder:
                    (child) => Material(
                      elevation: 1.0,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      child: child,
                    ),
                onPredictionWithCoordinatesReceived: (prediction) {
                  // Do something with the place details with coordinates
                  //print('placeDetails${prediction.lng}');
                },
                onSuggestionClicked:
                    (Prediction prediction) =>
                        _textController.text = prediction.description!,
                minInputLength: 3,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(onPressed: _onSubmit, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.always);
      return;
    }
  }
}
