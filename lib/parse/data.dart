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
  /// The `"nickname"` field, used as a primary display name when set,
  /// pushing [name] to a lower priority.
  final String? nickname;
  /// The `"links"` field, which holds links to Web pages or other Myfiles.
  final List<ParsedMyfileLinkData> links;

  /// Warnings presented during parsing.
  final List<ParsingWarning> warnings;

  ParsedMyfileData({
    this.name, this.imageUrl, this.description, this.nickname,
    this.links = const [], this.bannerUrl, this.warnings = const []
  });
}

class ParsedMyfileLinkData {
  final String? label;
  final String url;

  ParsedMyfileLinkData(this.url, [this.label]);
}

class ParsingWarning {
  final String title;
  final String message;
  ParsingWarning(this.title, this.message);
}