class PlacesAutocompleteResponse {
  List<Prediction>? predictions;
  String? status;

  PlacesAutocompleteResponse({this.predictions, this.status});

  PlacesAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    if (json['predictions'] != null) {
      predictions = [];
      json['predictions'].forEach((v) {
        predictions!.add(Prediction.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (predictions != null) {
      data['predictions'] = predictions!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Prediction {
  String? description;
  String? id;
  List<MatchedSubstrings>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Terms>? terms;
  List<String>? types;
  String? lat;
  String? lng;

  Prediction(
      {this.description,
      this.id,
      this.matchedSubstrings,
      this.placeId,
      this.reference,
      this.structuredFormatting,
      this.terms,
      this.types,
      this.lat,
      this.lng});

  Prediction.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
    if (json['matched_substrings'] != null) {
      matchedSubstrings = [];
      json['matched_substrings'].forEach((v) {
        matchedSubstrings!.add(MatchedSubstrings.fromJson(v));
      });
    }
    placeId = json['place_id'];
    reference = json['reference'];
    structuredFormatting = json['structured_formatting'] != null
        ? StructuredFormatting.fromJson(json['structured_formatting'])
        : null;
    if (json['terms'] != null) {
      terms = [];
      json['terms'].forEach((v) {
        terms!.add(Terms.fromJson(v));
      });
    }
    types = json['types'].cast<String>();
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['id'] = id;
    if (matchedSubstrings != null) {
      data['matched_substrings'] =
          matchedSubstrings!.map((v) => v.toJson()).toList();
    }
    data['place_id'] = placeId;
    data['reference'] = reference;
    if (structuredFormatting != null) {
      data['structured_formatting'] = structuredFormatting!.toJson();
    }
    if (terms != null) {
      data['terms'] = terms!.map((v) => v.toJson()).toList();
    }
    data['types'] = types;
    data['lat'] = lat;
    data['lng'] = lng;

    return data;
  }
}

class MatchedSubstrings {
  int? length;
  int? offset;

  MatchedSubstrings({this.length, this.offset});

  MatchedSubstrings.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = length;
    data['offset'] = offset;
    return data;
  }
}

class StructuredFormatting {
  String? mainText;

  String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  StructuredFormatting.fromJson(Map<String, dynamic> json) {
    mainText = json['main_text'];

    secondaryText = json['secondary_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['main_text'] = mainText;
    data['secondary_text'] = secondaryText;
    return data;
  }
}

class Terms {
  int? offset;
  String? value;

  Terms({this.offset, this.value});

  Terms.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offset'] = offset;
    data['value'] = value;
    return data;
  }
}
