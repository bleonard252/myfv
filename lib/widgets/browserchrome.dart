import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myfv/about_pages/router.dart';
import 'package:myfv/helpers/load.dart';
import 'package:myfv/helpers/page.dart';
import 'package:myfv/render/main.dart';
import 'package:myfv/widgets/errorpage.dart';

final StateProvider<List<MyfvPage>> tabs = StateProvider((ref) => [
  UnloadedPage("file://C:/Users/La Esperantisto/Projects/myfv/test/goldenfiles/test_target_file_1.json")
]);

class BrowserChrome extends StatefulWidget {
  const BrowserChrome({ Key? key }) : super(key: key);
  /// Used for the [RepaintBoundary] so that it can take screenshots of the tab
  /// currently being displayed in it.
  static final tabRenderBoundsKey = UniqueKey();

  @override
  _BrowserChromeState createState() => _BrowserChromeState();
}

class _BrowserChromeState extends State<BrowserChrome> {
  /// Current tab index
  int currentTab = 0; //TODO: find a better way to do this, maybe
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _AddressBar(currentTab: currentTab),
          Expanded(
            child: RepaintBoundary(
              child: Consumer(builder: (context, ref, child) {
                final _tabs = ref.watch(tabs);
                var tab = _tabs.state[currentTab];
                if (tab is UnloadedPage && tab.address.startsWith("about:")) 
                  return aboutRouter.route(tab.address.replaceFirst("about:", "/"));
                if (tab is UnloadedPage) {
                  if (tab.address.contains("://")) {
                    if (tab.address.startsWith("file://")) {
                      // TODO: check if it's a Myfile or a webpage
                      return FutureBuilder(
                        future: loadMyfileFromFile(tab.address.replaceFirst("file://", "")).then((data) {
                          tab = data;
                          _tabs.state[currentTab] = tab;
                          setState(() {});
                        }),
                        builder: (context, snapshot) => snapshot.hasError || snapshot.hasData ? ErrorScreen(
                          icon: Icon(MdiIcons.syncOff),
                          title: Text("Failed to load"),
                          text: [Text(snapshot.error.toString())],
                          errorCode: Text(snapshot.error.runtimeType.toString()),
                        ) : Center(child: CircularProgressIndicator(value: null))
                      );
                    }
                    else {
                      tab = LoadedWebPage(tab.address, tabKey: UniqueKey());
                      _tabs.state[currentTab] = tab;
                      setState(() {});
                    }
                  } else if (tab.address.contains("//")) return ErrorScreen(
                    icon: Icon(Icons.browser_not_supported),
                    title: Text("Unimplemented operation"),
                    text: [
                      Text("Looking up Myfiles by address is not yet supported")
                    ],
                    errorCode: Text("MYFV: UNIMPLEMENTED_OPERATION (MYFILE_LOOKUP)"),
                  ); else return ErrorScreen(
                    icon: Icon(Icons.browser_not_supported),
                    title: Text("Unimplemented operation"),
                    text: [
                      Text("Loading pages is not yet supported")
                    ],
                    errorCode: Text("MYFV: UNIMPLEMENTED_OPERATION (PAGE_LOAD)"),
                  );
                } if (tab is ErrorPage) return tab.page;
                if (tab is LoadedMyfilePage) return RenderedMyfileScreen(myfile: tab.parsedMyfile);
                // return ErrorScreen(
                //   icon: Icon(Icons.browser_not_supported),
                //   title: Text("Unimplemented operation"),
                //   text: [
                //     Text("Rendering Myfiles is not yet supported")
                //   ],
                //   errorCode: Text("MYFV: UNIMPLEMENTED_OPERATION (MYFILE_RENDER)"),
                // );
                else if (tab is LoadedWebPage) return ErrorScreen(
                  icon: Icon(Icons.browser_not_supported),
                  title: Text("Unimplemented operation"),
                  text: [
                    Text("Rendering webpages is not yet supported")
                  ],
                  errorCode: Text("MYFV: UNIMPLEMENTED_OPERATION (WEB_RENDER)"),
                ); else throw UnsupportedError("An invalid tab type was provided (${tab.runtimeType})");
              }),
              key: BrowserChrome.tabRenderBoundsKey
            )
          )
        ],
        mainAxisSize: MainAxisSize.max,
      ),
    );
  }
}

class _AddressBar extends ConsumerStatefulWidget {
  /// The tab index. Used to differentiate address bars.
  final int currentTab;
  _AddressBar({
    Key? key,
    this.currentTab = 0
  }) : super(key: key);

  
  @override
  _AddressBarState createState() => _AddressBarState();
}
class _AddressBarState extends ConsumerState<_AddressBar> {

  late final TextEditingController addressBarController = TextEditingController(text: "about:blank");
  final FocusNode addressBarFocusNode = FocusNode();

  @override
  void initState() {
    addressBarController.text = ref.read(tabs).state[widget.currentTab].address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: set the address bar to the current page's address
    return Hero(
      tag: "AddressBar__tab-"+(widget.currentTab.toRadixString(16)),
      child: Material(
        color: Theme.of(context).primaryColor,
        elevation: 3,
        child: Row(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: HSVColor.fromColor(Theme.of(context).primaryColor).withSaturation(0.65).toColor(),
                borderRadius: BorderRadius.circular(64),
                clipBehavior: Clip.antiAlias,
                child: Row(mainAxisSize: MainAxisSize.max, children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final tab = ref.watch(tabs).state[widget.currentTab];
                      late final _SecurityInformation secInfo;
                      if (tab is UnloadedPage && tab.address.startsWith("about:")) secInfo = _SecurityInformation(
                        icon: Icon(Icons.verified, color: Colors.white),
                        label: "About page",
                        description: "This is a secure page, built into the app. Third parties cannot change the information displayed on these pages.",
                        backgroundColor: Colors.green
                      ); else if (tab is ErrorPage) tab.preConnection ? secInfo = _SecurityInformation(
                        icon: Icon(Icons.error_outline),
                        label: "Error page",
                        backgroundColor: Colors.amber,
                        description: "An error was encountered before the connection could be established."
                      ) : secInfo = _SecurityInformation(
                        icon: Icon(Icons.warning),
                        label: "Insecure error page",
                        backgroundColor: Colors.red,
                        description: "An error was encountered after the connection was established. Any sensitive information sent may have been comprimized."
                      ); else if (tab is LoadedMyfilePage) secInfo = _SecurityInformation(
                        // TODO: Myfiles have additional security information to use in the security popup; use it
                        icon: Icon(Icons.edit_road),
                        label: "Myfile"
                      ); else if (tab is LoadedWebPage) secInfo = _SecurityInformation(
                        icon: Icon(Icons.lock),
                        label: "Secure Web page"
                      ); else secInfo = _SecurityInformation(
                        icon: Icon(Icons.error, color: Colors.red),
                        label: "Insecure connection"
                      );
                      return Consumer(
                        builder: (ctx, ref, child) => secInfo.backgroundColor == null ? child! : ClipPath(
                          clipper: _SlantClipper(),
                          child: child
                        ),
                        child: Material(
                          color: secInfo.backgroundColor ?? Colors.transparent,
                          child: Tooltip(
                            message: secInfo.label,
                            child: IconButton(
                              onPressed: () => {},
                              icon: secInfo.icon,
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextField(
                        controller: addressBarController,
                        focusNode: addressBarFocusNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                        ),
                        textInputAction: TextInputAction.go,
                        keyboardType: TextInputType.url,
                        maxLines: 1,
                        onSubmitted: (value) {
                          final _x = [...ref.read(tabs).state];
                          _x[widget.currentTab] = UnloadedPage(value);
                          ref.read(tabs).state = _x;
                          //setState(() {});
                        },
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ),
          IconButton(
            onPressed: () => null,
            icon: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: Text(ref.read(tabs).state.length.toString(), style: Theme.of(context).primaryTextTheme.bodyText1),
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
    );
  }
}

class _SecurityInformation {
  final Icon icon;
  final String label;
  /// A background color sometimes used for certain types of pages.
  final Color? backgroundColor;
  @Deprecated("Unused for now")
  final String description;
  _SecurityInformation({required this.icon, required this.label, this.description = "Unused for now", this.backgroundColor});
}

// The "slant" clip shape
class _SlantClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
    ..addPolygon([
      Offset(0, 0),
      Offset(size.width, 0),
      Offset(size.width-16, size.height),
      Offset(0, size.height)
    ], true);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }

}