import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myfv/parse/parse.dart';

main() {
  group("Test Target File 1", () {
    late var json;
    setUp(() async {
      // Load the file
      final file = File("test/goldenfiles/test_target_file_1.json");
      // Read the file as JSON (subject to change)
      json = jsonDecode(await file.readAsString());
    });
    test("Basic information test", () async {
      // Parse the file
      final data = parseMyfileFromJson(json);
      expect(data.name, "Test Target File 1");
      expect(data.description, "TTF1 is used as the baseline for other tests. It demonstrates the most basic functionality for a Myfile.");
      expect(data.imageUrl, "https://www.imore.com/sites/imore.com/files/field/image/2019/09/untitled-goose-game.jpg");
      assert(data.warnings.isEmpty, "There is at least one warning! ${data.warnings}");
    });
    test("Image test", () async {
      // Parse the file
      final data = parseMyfileFromJson(json);
      assert(data.image != null);
      assert((data.image as NetworkImage).url == data.imageUrl, "Image URL should match given ImageURL for this image");
      assert(data.warnings.isEmpty, "There is at least one warning! ${data.warnings}");
    });
  });
  group("Test Target File 2", () {
    late var json;
    setUp(() async {
      // Load the file
      final file = File("test/goldenfiles/test_target_file_2.json");
      // Read the file as JSON (subject to change)
      json = jsonDecode(await file.readAsString());
    });
    test("Link test", () async {
      // Parse the file
      final data = parseMyfileFromJson(json);
      expect(data.links.length, 1);
      assert(data.warnings.isEmpty, "There is at least one warning! ${data.warnings}");
    });
  });
}