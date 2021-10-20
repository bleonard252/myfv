import "package:flutter/material.dart";
import 'package:myfv/about_pages/router.dart';
import 'package:routemaster/routemaster.dart';

class BrowserChrome extends StatefulWidget {
  const BrowserChrome({ Key? key }) : super(key: key);

  @override
  _BrowserChromeState createState() => _BrowserChromeState();
}

class _BrowserChromeState extends State<BrowserChrome> {
  late final Routemaster _routemaster;
  TextEditingController? addressBarController;
  final FocusNode addressBarFocusNode = FocusNode(debugLabel: "Address bar (focus)");
  @override
  Widget build(BuildContext context) {
    try {
      addressBarController = TextEditingController(text: _routemaster.currentRoute.fullPath);
    } catch (_) {
      addressBarController = TextEditingController(text: "about:blank");
    }
    return Scaffold(
      body: Column(
        children: [
          Material(
            color: Theme.of(context).primaryColor,
            elevation: 3,
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: HSVColor.fromColor(Theme.of(context).primaryColor).withSaturation(0.65).toColor(),
                    borderRadius: BorderRadius.circular(16),
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      Tooltip(
                        message: "Local file",
                        child: IconButton(
                          onPressed: () => {},
                          icon: Icon(Icons.insert_drive_file),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0)
                        )
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextField(
                            controller: addressBarController,
                            focusNode: addressBarFocusNode,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  
                },
                icon: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  child: Text("1", style: Theme.of(context).primaryTextTheme.bodyText1),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryTextTheme.bodyText1?.color ?? Colors.black,
                      style: BorderStyle.solid,
                      width: 2
                    ),
                    borderRadius: BorderRadius.circular(2)
                  ),
                )
              ),
              IconButton(onPressed: () => {}, icon: Icon(Icons.more_vert, color: Theme.of(context).primaryTextTheme.bodyText1?.color))
            ])
          ),
          MaterialApp.router(
            routeInformationParser: RoutemasterParser(),
            routerDelegate: aboutRouter,
            theme: Theme.of(context),
            debugShowCheckedModeBanner: false,
          )
        ],
        mainAxisSize: MainAxisSize.max,
      ),
    );
  }
}