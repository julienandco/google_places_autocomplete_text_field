library google_places_autocomplete_text_field;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'package:google_places_autocomplete_text_field/model/place_details.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';

class GooglePlacesAutoCompleteTextFormField extends StatefulWidget {
  final String? initialValue;
  final FocusNode? focusNode;
  final TextEditingController textEditingController;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;
  final bool enableIMEPersonalizedLearning;
  final MouseCursor? mouseCursor;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final String? Function(String?)? validator;

  /// Specific to this package
  final ItemClick? itmClick;
  final GetPlaceDetailsWithLatLng? getPlaceDetailsWithLatLng;
  final bool isLatLngRequired;
  final String googleAPIKey;
  final int debounceTime;
  final List<String>? countries;
  final TextStyle? predictionsStyle;
  final OverlayContainer? overlayContainer;
  final String? proxyURL;
  final int? minInputLength;
  final bool useSessionToken;

  const GooglePlacesAutoCompleteTextFormField({
    super.key,

    ///// SPECIFIC TO THIS PACKAGE
    required this.textEditingController,
    required this.googleAPIKey,
    this.debounceTime = 600,
    this.itmClick,
    this.isLatLngRequired = true,
    this.countries = const [],
    this.getPlaceDetailsWithLatLng,
    this.predictionsStyle,
    this.overlayContainer,
    this.proxyURL,
    this.minInputLength,
    this.useSessionToken = true,

    ////// DEFAULT TEXT FORM INPUTS
    this.initialValue,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.maxLines,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.enableIMEPersonalizedLearning = true,
    this.mouseCursor,
    this.contextMenuBuilder,
    this.validator,
  });

  @override
  State<GooglePlacesAutoCompleteTextFormField> createState() =>
      _GooglePlacesAutoCompleteTextFormFieldState();
}

class _GooglePlacesAutoCompleteTextFormFieldState
    extends State<GooglePlacesAutoCompleteTextFormField> {
  final subject = PublishSubject<String>();
  OverlayEntry? _overlayEntry;
  List<Prediction> allPredictions = [];
  String? sessionToken;

  final LayerLink _layerLink = LayerLink();
  bool isSearched = false;

  final Dio _dio = Dio();
  late FocusNode _focus;

  @override
  void initState() {
    subject.stream
        .distinct()
        .debounceTime(Duration(milliseconds: widget.debounceTime))
        .listen(textChanged);

    _focus = widget.focusNode ?? FocusNode();

    if (!kIsWeb && !Platform.isMacOS) {
      _focus.addListener(() {
        if (!_focus.hasFocus) {
          removeOverlay();
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: widget.textEditingController,
        initialValue: widget.initialValue,
        focusNode: _focus,
        decoration: widget.decoration,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        style: widget.style,
        strutStyle: widget.strutStyle,
        textDirection: widget.textDirection,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        showCursor: widget.showCursor,
        obscuringCharacter: widget.obscuringCharacter,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
        enableSuggestions: widget.enableSuggestions,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        expands: widget.expands,
        maxLength: widget.maxLength,
        onChanged: (string) {
          widget.onChanged?.call(string);
          subject.add(string);
        },
        onTap: widget.onTap,
        onTapOutside: widget.onTapOutside,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        cursorWidth: widget.cursorWidth,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorColor: widget.cursorColor,
        keyboardAppearance: widget.keyboardAppearance,
        scrollPadding: widget.scrollPadding,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        selectionControls: widget.selectionControls,
        buildCounter: widget.buildCounter,
        scrollPhysics: widget.scrollPhysics,
        autofillHints: widget.autofillHints,
        autovalidateMode: widget.autovalidateMode,
        scrollController: widget.scrollController,
        enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
        mouseCursor: widget.mouseCursor,
        contextMenuBuilder: widget.contextMenuBuilder,
        validator: widget.validator,
      ),
    );
  }

  Future<void> getLocation(String text) async {
    if (text.isEmpty || text.length < (widget.minInputLength ?? 0)) {
      allPredictions.clear();
      _overlayEntry?.remove();
      return;
    }

    final prefix = widget.proxyURL ?? "";
    PlacesAutocompleteResponse subscriptionResponse;

    if (widget.useSessionToken && sessionToken == null) {
      var uuid = const Uuid();
      sessionToken = widget.useSessionToken ? uuid.v4() : null;
    }

    String url =
        "${prefix}https://places.googleapis.com/v1/places:autocomplete";

    Map<String, dynamic> requestBody = {"input": text};

    if (widget.countries != null) {
      requestBody["includedRegionCodes"] = widget.countries;
    }
    if (sessionToken != null) {
      requestBody["sessionToken"] = sessionToken;
    }
    Options options = Options(
      headers: {"X-Goog-Api-Key": widget.googleAPIKey},
    );

    try {
      final response =
          await _dio.post(url, options: options, data: jsonEncode(requestBody));
      subscriptionResponse = PlacesAutocompleteResponse.fromJson(response.data);

      isSearched = false;
      if (subscriptionResponse.predictions!.isNotEmpty) {
        allPredictions.clear();
        allPredictions.addAll(subscriptionResponse.predictions!);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> textChanged(String text) async {
    final overlay = Overlay.of(context);
    getLocation(text).then(
      (_) {
        _overlayEntry = null;
        _overlayEntry = _createOverlayEntry();
        overlay.insert(_overlayEntry!);
      },
    );
  }

  OverlayEntry? _createOverlayEntry() {
    if (context.findRenderObject() != null) {
      final renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);

      return OverlayEntry(
        builder: (context) => Positioned(
          left: offset.dx,
          top: size.height + offset.dy,
          width: size.width,
          child: CompositedTransformFollower(
            showWhenUnlinked: false,
            link: _layerLink,
            offset: Offset(0.0, size.height + 5.0),
            child: widget.overlayContainer?.call(_overlayChild) ??
                Material(
                  elevation: 1.0,
                  child: _overlayChild,
                ),
          ),
        ),
      );
    }
    return null;
  }

  Widget get _overlayChild {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: allPredictions.length,
      itemBuilder: (BuildContext context, int index) => InkWell(
        onTap: () {
          if (index < allPredictions.length) {
            widget.itmClick!(allPredictions[index]);
            if (!widget.isLatLngRequired) return;

            getPlaceDetailsFromPlaceId(allPredictions[index]);

            removeOverlay();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            allPredictions[index].description!,
            style: widget.predictionsStyle ?? widget.style,
          ),
        ),
      ),
    );
  }

  void removeOverlay() {
    allPredictions.clear();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _overlayEntry!.markNeedsBuild();
  }

  Future<void> getPlaceDetailsFromPlaceId(Prediction prediction) async {
    try {
      final prefix = widget.proxyURL ?? "";

      String url =
          "${prefix}https://places.googleapis.com/v1/places/${prediction.placeId}?fields=*&key=${widget.googleAPIKey}";
      if (sessionToken != null) {
        url += "&sessionToken=$sessionToken";
        sessionToken = null; // Reset session token
      }
      final response = await _dio.get(url);

      final placeDetails = PlaceDetails.fromJson(response.data);

      prediction.lat = placeDetails.result!.geometry!.location!.lat.toString();
      prediction.lng = placeDetails.result!.geometry!.location!.lng.toString();

      widget.getPlaceDetailsWithLatLng!(prediction);
    } catch (e) {
      rethrow;
    }
  }
}

PlacesAutocompleteResponse parseResponse(Map responseBody) =>
    PlacesAutocompleteResponse.fromJson(responseBody as Map<String, dynamic>);

PlaceDetails parsePlaceDetailMap(Map responseBody) =>
    PlaceDetails.fromJson(responseBody as Map<String, dynamic>);

typedef ItemClick = void Function(Prediction prediction);
typedef GetPlaceDetailsWithLatLng = void Function(Prediction prediction);
typedef OverlayContainer = Widget Function(Widget overlayChild);
