import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final aboutRouter = RoutemasterDelegate(
  routesBuilder: (context) => RouteMap(routes: {
    "/blank": (context) => MaterialPage(child: Material(color: Colors.white))
  })
);