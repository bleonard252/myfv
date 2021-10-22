import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:myfv/parse/parse.dart';

main() {
  test("Test Target File 1", () async {
    // Load the file
    final file = File("test/goldenfiles/test_target_file_1.json");
    // Read the file as JSON (subject to change)
    final json = jsonDecode(await file.readAsString());
    // Parse the file
    final data = parseMyfileFromJson(json);
    // Make sure the file is parsed correctly,
    // checking the weak points first (such as images)
    expect(data.name, "Test Target File 1");
    expect(data.description, "TTF1 is used as the baseline for other tests. It demonstrates the most basic functionality for a Myfile.");
    expect(data.imageUrl, "https://www.imore.com/sites/imore.com/files/field/image/2019/09/untitled-goose-game.jpg");
  });
}