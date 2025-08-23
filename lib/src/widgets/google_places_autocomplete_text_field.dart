import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:rxdart/rxdart.dart';

/// {@template google_places_autocomplete_text_form_field}
/// A [TextFormField] that provides autocompletion suggestions based on the
/// user's input, using the new Google Places API
/// (https://developers.google.com/maps/documentation/places/web-service/op-overview).
/// {@endtemplate}
class GooglePlacesAutoCompleteTextFormField extends StatefulWidget {
  /// {@macro google_places_autocomplete_text_form_field}
  const GooglePlacesAutoCompleteTextFormField({
    required this.config,
    this.textEditingController,
    this.onSuggestionClicked,
    this.onPredictionWithCoordinatesReceived,
    this.predictionsStyle,
    this.overlayContainerBuilder,
    this.minInputLength = 0,
    this.initialValue,
    this.fetchSuggestionsForInitialValue = false,
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
    this.maxHeight = 200,
    this.onError,
    this.keepFocusAfterSuggestionSelection = false,
    super.key,
  });

  /// The configuration for the Google API to be used during any request.
  final GoogleApiConfig config;

  /// The initial value to be held inside the text form field. If this is not
  /// null and [textEditingController] is not null as well, this value will be
  /// set inside the controller.
  final String? initialValue;

  /// Whether the suggestions should be fetched for the initial value. If this
  /// is set to true, the suggestions will be fetched immediately, as soon as
  /// the widget is built. The suggestions will only be fetched if the initial
  /// value is not null.
  final bool fetchSuggestionsForInitialValue;

  /// The FocusNode that controls this text form field. If this is null, a new
  /// FocusNode will be created.
  final FocusNode? focusNode;

  /// The TextEditingController that controls this text form field. If this is
  /// null, no TextEditingController will be created.
  final TextEditingController? textEditingController;

  /// The callback executed when the user clicks on a suggestion. The prediction
  /// that was clicked will be passed as an argument.
  final void Function(Prediction prediction)? onSuggestionClicked;

  /// The callback that is called as soon as the prediction with the
  /// coordinates are received.
  final void Function(Prediction prediction)?
  onPredictionWithCoordinatesReceived;

  /// The text style of the predictions that are shown in the suggestions list.
  final TextStyle? predictionsStyle;

  /// The widget that is shown as an overlay to the text form field. If this is
  /// null, a default Material widget will be used.
  final Widget Function(Widget overlayChild)? overlayContainerBuilder;

  /// The minimum length of the input that is required to send a request to the
  /// Google Places API. If the input is shorter than this value, no request
  /// will be sent.
  final int minInputLength;

  /// The maximum height of the suggestions list [OverlayContainer]. If a custom
  /// [overlayContainerBuilder] is provided, this value will be ignored.
  final double maxHeight;

  /// The callback that is called when an error occurs during the API request.
  final Function? onError;

  /// Whether the focus should be kept on the text field after a suggestion is
  /// selected.
  final bool keepFocusAfterSuggestionSelection;

  // The following properties are the same as the ones in the TextFormField
  // widget. They are used to customize the text form field.
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

  @override
  State<GooglePlacesAutoCompleteTextFormField> createState() =>
      _GooglePlacesAutoCompleteTextFormFieldState();
}

class _GooglePlacesAutoCompleteTextFormFieldState
    extends State<GooglePlacesAutoCompleteTextFormField> {
  final subject = PublishSubject<String>();
  late GooglePlacesApi _api;
  OverlayEntry? _overlayEntry;
  List<Prediction> allPredictions = [];

  final LayerLink _layerLink = LayerLink();

  late FocusNode _focus;
  late StreamSubscription<String> subscription;
  CancelableOperation? cancelableOperation;

  @override
  void dispose() {
    subscription.cancel();
    subject.close();
    _focus.dispose();
    if (cancelableOperation != null) {
      cancelableOperation?.cancel();
    }

    super.dispose();
  }

  @override
  void initState() {
    _api = GooglePlacesApi();
    subscription = subject.stream
        .distinct()
        .debounceTime(Duration(milliseconds: widget.config.debounceTime))
        .listen(textChanged);

    _focus = widget.focusNode ?? FocusNode();

    if (!kIsWeb && !Platform.isMacOS) {
      _focus.addListener(() {
        if (!_focus.hasFocus) {
          removeOverlay();
        }
      });
    }

    if (widget.initialValue != null && widget.fetchSuggestionsForInitialValue) {
      subject.add(widget.initialValue!);
    }

    if (widget.initialValue != null && widget.textEditingController != null) {
      widget.textEditingController!.text = widget.initialValue!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: widget.textEditingController,
        initialValue:
            widget.textEditingController != null ? null : widget.initialValue,
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
    if (text.isEmpty || text.length < widget.minInputLength) {
      allPredictions.clear();
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
      return;
    }

    try {
      final result = await _api.getSuggestionsForInput(
        input: text,
        config: widget.config,
      );
      if (result == null) return;
      final predictions = result.predictions;
      if (predictions == null || predictions.isEmpty) return;

      allPredictions.clear();
      allPredictions.addAll(predictions);
    } catch (e) {
      debugPrint('getLocation: ${e.toString()}');
      if (e is DioException) {
        widget.onError?.call(e.response);
      } else {
        widget.onError?.call(e);
      }
    }
  }

  Future<void> getPlaceDetailsFromPlaceId(Prediction prediction) async {
    final predictionWithCoordinates = await _api.fetchCoordinatesForPrediction(
      prediction: prediction,
      config: widget.config,
    );
    if (predictionWithCoordinates == null) return;
    widget.onPredictionWithCoordinatesReceived?.call(predictionWithCoordinates);
  }

  Future<dynamic> fromCancelable(Future<dynamic> future) async {
    cancelableOperation = CancelableOperation.fromFuture(
      future,
      onCancel: () {},
    );
    return cancelableOperation?.value;
  }

  Future<void> textChanged(String text) async {
    final overlay = Overlay.of(context);
    fromCancelable(getLocation(text)).then((_) {
      try {
        _overlayEntry?.remove();
      } catch (_) {}

      _overlayEntry = null;
      _overlayEntry = _createOverlayEntry();
      overlay.insert(_overlayEntry!);
    });
  }

  OverlayEntry? _createOverlayEntry() {
    if (context.findRenderObject() != null) {
      final renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);

      return OverlayEntry(
        builder:
            (context) => Positioned(
              left: offset.dx,
              top: size.height + offset.dy,
              width: size.width,
              child: CompositedTransformFollower(
                showWhenUnlinked: false,
                link: _layerLink,
                offset: Offset(0.0, size.height + 5.0),
                child:
                    widget.overlayContainerBuilder?.call(_overlayChild) ??
                    Material(
                      elevation: 1.0,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: widget.maxHeight,
                        ),
                        child: _overlayChild,
                      ),
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
      itemBuilder: (BuildContext context, int index) {
        final prediction = allPredictions.elementAt(index);
        return InkWell(
          onTap: () {
            if (index < allPredictions.length) {
              widget.onSuggestionClicked?.call(prediction);
              if (widget.config.fetchPlaceDetailsWithCoordinates) {
                getPlaceDetailsFromPlaceId(prediction);
              }
              if (!widget.keepFocusAfterSuggestionSelection) {
                _focus.unfocus();
              }
              removeOverlay();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              prediction.description!,
              style: widget.predictionsStyle ?? widget.style,
            ),
          ),
        );
      },
    );
  }

  void removeOverlay() {
    allPredictions.clear();
    try {
      _overlayEntry?.remove();
    } catch (_) {}

    _overlayEntry?.dispose();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _overlayEntry!.markNeedsBuild();
  }
}
