import 'package:flutter/rendering.dart';

class ParsedMyfileData {
  /// This may be used for editable Myfiles in the future but for now it is always false,
  /// since myfv cannot yet be used to edit Myfiles.
  final bool editable = false;
  
  /// The `"name"` field, used for the primary display name,
  /// unless a [nickname] is set.
  final String? name;
  /// The `"image"` field, parsed into a real URL if necessary.
  final String? imageUrl;
  // final ImageProvider? image;
  /// The `"banner"` field, parsed into a real URL if necessary.
  final String? bannerUrl;
  // final ImageProvider? banner;
  /// The `"description"` field, used for bios and object descriptions.
  final String? description;
  /// The `"pronouns"` field, advertising the owner's preferred pronouns.
  final String? pronouns;
  /// The `"nickname"` field, used as a primary display name when set,
  /// pushing [name] to a lower priority.
  final String? nickname;
  /// The `"links"` field, which holds links to Web pages or other Myfiles.
  final List<ParsedMyfileLinkData> links;
  /// A list of Myfile cards.
  final List<MyfileCard> cards;

  /// Warnings presented during parsing.
  final List<ParsingWarning> warnings;

  ParsedMyfileData({
    this.name, this.imageUrl, this.description, this.nickname,
    this.links = const [], this.bannerUrl, this.warnings = const [],
    this.cards = const [], this.pronouns
  });

  /// Get the image data as an [ImageProvider], useful in the Image widget.
  ImageProvider? get image => (imageUrl?.startsWith("https://") ?? false) ? NetworkImage(imageUrl!) : null;
  /// Get the image data as an [ImageProvider], useful in the Image widget.
  ImageProvider? get banner => (bannerUrl?.startsWith("https://") ?? false) ? NetworkImage(bannerUrl!) : null;
}

class ParsedMyfileLinkData {
  final String? label;
  final String url;

  ParsedMyfileLinkData(this.url, [this.label]);
}

mixin MyfileCard {}

class BasicMyfileCard with MyfileCard {
  final String? title;
  final String? text;
  final String? imageUrl;

  BasicMyfileCard({this.title, this.text, this.imageUrl});

  /// Get the image data as an [ImageProvider], useful in the Image widget.
  ImageProvider? get image => (imageUrl?.startsWith("https://") ?? false) ? NetworkImage(imageUrl!) : null;
}

/// Warnings for:
/// * anti-patterns
/// * ignored fields
/// * invalid fields, keys, or values
/// * deprecations
/// * duplicate fields, keys, or values
class ParsingWarning {
  final String title;
  final String message;
  ParsingWarning(this.title, this.message);

  @override
  String toString() => "$title [PARSING WARNING] $message";
}
/// Grouped with warnings but not counted, these contain tips to make users'
/// Myfiles better across different apps or on this one.
/// This should **never** mention unrelated features or advertise anything.
class ParsingRecommendation extends ParsingWarning {
  ParsingRecommendation(String title, String message) : super(title, message);
}