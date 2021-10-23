import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myfv/helpers/page.dart';
import 'package:myfv/parse/parse.dart';
import 'package:myfv/widgets/errorpage.dart';

Future<MyfvPage> loadMyfileFromFile(String address) async {
  if (kIsWeb) return ErrorPage(address, page: ErrorScreen(
    icon: Icon(MdiIcons.webOff),
    title: Text("Not supported"),
    text: [Text("Loading files via URL via a web browser is not supported.")],
    errorCode: Text("MYFV: PLATFORM_OPERATION_NOT_SUPPORTED (WEB, FILEURLS)"),
  ), preConnection: true);
  final lookupAddress = address.replaceFirst("file://", "");
  if ((Platform.isWindows && !lookupAddress.startsWith(RegExp("[a-zA-Z]\:/")))
  || (!Platform.isWindows && !lookupAddress.startsWith("/")))
    return ErrorPage(address, lookupAddress: lookupAddress, page: ErrorScreen(
      icon: Icon(Icons.zoom_in),
      title: Text("Invalid address format"),
      text: [
        Text("The file path you used is incorrectly formatted. Try the following:"),
        if (Platform.isWindows) Text("* Make sure the file path starts with a drive letter. UNC paths are not yet supported.")
        else Text("* Make sure the path starts with an additional forward slash."),
        if (Platform.isWindows) Text("* If you used back-slashes (\\) in your file path, try inverting them to forward-slashes (/)."),
        Text("* Make sure the file path is absolute.")
      ],
    ), preConnection: true);
  // Load the file
  final file = File(lookupAddress);
  if (!await file.exists()) return ErrorPage(address, lookupAddress: lookupAddress, page: ErrorScreen(
    icon: Icon(MdiIcons.ghost),
    title: Text("Not found"),
    text: [
      Text("The file you were trying to read was not found."),
      Text("You were trying to get to: $lookupAddress")
    ],
  ), preConnection: true);
  // Read the file as JSON (subject to change)
  final json = jsonDecode(await file.readAsString());
  return LoadedMyfilePage(parseMyfileFromJson(json), address: address, lookupAddress: lookupAddress);
}