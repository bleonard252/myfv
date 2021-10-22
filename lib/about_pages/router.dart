import 'package:flutter/material.dart';
import 'package:myfv/widgets/errorpage.dart';
import 'package:routemaster/routemaster.dart';

final aboutRouter = RoutemasterDelegate(
  routesBuilder: (context) => RouteMap(routes: {
    "/blank": (context) => MaterialPage(child: Material(color: Colors.red))
  }, onUnknownRoute: (context) => MaterialPage(
    child: ErrorScreen(
      icon: Icon(Icons.cancel_presentation),
      title: Text("Invalid about: page"),
      text: [
        Text("The URL is invalid. Please check the address you used, then try again.")
      ],
      errorCode: Text("MYFV: INVALID_ABOUT_PAGE"),
    )
  )),
);