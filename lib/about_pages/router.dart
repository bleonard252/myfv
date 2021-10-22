import 'package:flutter/material.dart';
import 'package:myfv/widgets/errorpage.dart';

// final aboutRouter = RoutemasterDelegate(
//   routesBuilder: (context) => RouteMap(routes: {
//     "/": (context) => Redirect(routeholder),
//     "/blank": (context) => MaterialPage(child: Material(color: Colors.red))
//   }, onUnknownRoute: (path) => MaterialPage(
//     child: ErrorScreen(
//       icon: Icon(Icons.cancel_presentation),
//       title: Text("Invalid about: page"),
//       text: [
//         Text("The URL is invalid. Please check the address you used, then try again."),
//         Text("You tried to go to: about:$path")
//       ],
//       errorCode: Text("MYFV: INVALID_ABOUT_PAGE"),
//     )
//   )),
//   observers: [_InitObserver()]
// );

// var routeholder = "/routeheld";

// class _InitObserver extends RoutemasterObserver {
//   bool _didFire = false;

//   @override
//   void didPush(a, b) {
//     if (_didFire) return;
//     if (a.navigator == null) return;
//     Routemaster.of(a.navigator!.context).push(routeholder);
//     _didFire = true;
//   }
// }

final aboutRouter = AboutRouter(
  routes: {
    "/blank": (context) => Material(color: Colors.red, child: Container(alignment: Alignment.center)),
    "/home": (context) => ErrorScreen(
      icon: Icon(Icons.house_outlined),
      title: Text("Homepage missing"),
      text: [],
      errorCode: Text("MYFV: UNIMPLEMENTED_ERROR (HOMEPAGE)"),
    )
  },
  onUnknownRoute: (context, path) => ErrorScreen(
    icon: Icon(Icons.cancel_presentation),
    title: Text("Invalid about: page"),
    text: [
      Text("The URL is invalid. Please check the address you used, then try again.")
      //Text("You tried to go to: about:$path")
    ],
    errorCode: Text("MYFV: INVALID_ABOUT_PAGE"),
  )
);

class AboutRouter {
  final Map<String, Widget Function(BuildContext context)> routes;
  final Widget Function(BuildContext context, String path)? onUnknownRoute;

  AboutRouter({required this.routes, this.onUnknownRoute});

  Widget route(String path) {
    late Widget Function(BuildContext context) _route;
    if (routes.containsKey(path)) _route = routes[path]!;
    else if (onUnknownRoute != null) _route = (context) => onUnknownRoute!(context, path);
    else _route = (context) => ErrorWidget(UnimplementedError());
    return Builder(builder: _route);
  }
}