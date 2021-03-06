import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data.dart';

typedef WarningCollector = StateController<List<ParsingWarning>>;
extension on WarningCollector {
  void warn(String title, String message) => this.state.add(ParsingWarning(title, message));
  void recommend(String title, String message) => this.state.add(ParsingRecommendation(title, message));
}

ParsedMyfileData parseMyfileFromJson(Map json) {
  final warningCollector = StateController<List<ParsingWarning>>([]);
  final image = json["image"] ?? json["picture"] ?? json["profile_picture"] ?? json["avatar"];
  final description = json["description"] ?? json["bio"] ?? json["about"];
  final List<ParsingWarning> warnings = [];
  final links = [
    for (var link in json["links"] ?? []) parseLinkFromJson(link, warningCollector)
  ];
  return ParsedMyfileData(
    name: (json["name"] is Map) ? (json["name"] as Map).values.join(" ") 
      // Maps are checked because `"name"` might indicate parts of a name,
      // such as first, middle, and last.
      // A more advanced dissection of that object will be needed at some point.
    : (json["name"] is String) ? json["name"] : null,
    imageUrl: image is String ? image : null,
    bannerUrl: json["banner"] is String ? json["banner"] : null,
    description: description is String ? description : null,
    nickname: json["nickname"] is String ? json["nickname"] : null,
    pronouns: json["pronouns"] is String ? json["pronouns"] : null,
    links: links.whereType<ParsedMyfileLinkData>().toList(),
    cards: parseCardsFromJson(json["cards"], warningCollector),
    warnings: warningCollector.state
  );
}

@protected
List<MyfileCard> parseCardsFromJson(dynamic json, [WarningCollector? warningCollector]) {
  if (json == null) return [];
  if (!(json is List)) {
    warningCollector?.warn("Invalid field format",
      "The \"cards\" field must be an array (list). The type used was ${json.runtimeType.toString()}."
    );
    return [];
  } else if (json is List && json.isEmpty) {
    warningCollector?.recommend("Empty field",
      "The \"cards\" field should have entries. The type used was ${json.runtimeType.toString()}."
    );
  }
  List<MyfileCard> output = [];
  for (var card in json) {
    if ((card["type"] ?? "basic") == "basic" && ((card["title"] ?? card["text"] ?? card["image"]) != null)) {
      output.add(BasicMyfileCard(
        title: card["title"],
        text: card["text"],
        imageUrl: card["image"]
      ));
    } else {
      warningCollector?.warn("Unknown card type",
        "A card had an unknown type. The type used was ${card["type"] ?? "basic"}."
      );
    }
  }
  return output;
}

@protected
ParsedMyfileLinkData? parseLinkFromJson(dynamic json, [WarningCollector? warningCollector]) {
  if (!(json is String)) {
    warningCollector?.warn("Invalid link format",
      "Links must be strings (text). Object links are not yet supported. The type used was ${json.runtimeType.toString()} and the value was ${json.toString()}."
    );
    return null;
  }
  final MarkdownLinkSyntax = RegExp(r"^\[(.*?)\]\((.*?)\)$");
  if (MarkdownLinkSyntax.hasMatch(json)) {
    final match = MarkdownLinkSyntax.firstMatch(json);
    if (match != null && match.groupCount == 2)
      return ParsedMyfileLinkData(match.group(2)!, match.group(1));
  } else { // maybe eventually add link format verifications, and add a warning if it's invalid
    return ParsedMyfileLinkData(json);
  }
}