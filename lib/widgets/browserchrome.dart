import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfv/about_pages/router.dart';
import 'package:myfv/helpers/page.dart';
import 'package:myfv/widgets/errorpage.dart';
import 'package:routemaster/routemaster.dart';

final StateProvider<List<MyfvPage>> tabs = StateProvider((ref) => [
  UnloadedPage("about:blank")
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
  late final Routemaster _routemaster;
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
                final tab = ref.watch(tabs).state[currentTab];
                if (tab is UnloadedPage && tab.address.startsWith("about:")) return MaterialApp.router(
                  routeInformationParser: RoutemasterParser(),
                  routerDelegate: aboutRouter
                  ..replace(tab.address.replaceFirst("about:", "/")),
                  theme: Theme.of(context),
                  debugShowCheckedModeBanner: false,
                );
                else if (tab is UnloadedPage) {
                  //TODO: load the page, parse if necessary, and update the tab list
                  return ErrorScreen(
                    icon: Icon(Icons.browser_not_supported),
                    title: Text("Unimplemented operation"),
                    text: [
                      Text("Loading pages is not yet supported")
                    ],
                    errorCode: Text("MYFV: UNIMPLEMENTED_OPERATION (PAGE_LOAD)"),
                  );
                } else if (tab is LoadedMyfilePage) return ErrorScreen(
                  icon: Icon(Icons.browser_not_supported),
                  title: Text("Unimplemented operation"),
                  text: [
                    Text("Rendering Myfiles is not yet supported")
                  ],
                  errorCode: Text("MYFV: UNIMPLEMENTED_OPERATION (MYFILE_RENDER)"),
                ); else if (tab is LoadedMyfilePage) return ErrorScreen(
                  icon: Icon(Icons.browser_not_supported),
                  title: Text("Unimplemented operation"),
                  text: [
                    Text("Rendering Myfiles is not yet supported")
                  ],
                  errorCode: Text("MYFV: UNIMPLEMENTED_OPERATION (MYFILE_RENDER)"),
                ); else if (tab is LoadedWebPage) return ErrorScreen(
                  icon: Icon(Icons.browser_not_supported),
                  title: Text("Unimplemented operation"),
                  text: [
                    Text("Rendering webpages is not yet supported")
                  ],
                  errorCode: Text("MYFV: UNIMPLEMENTED_OPERATION (WEB_RENDER)"),
                ); else throw UnsupportedError("An invalid tab type was provided.");
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
                  Tooltip( // tODO: change icons
                    message: "Local file",
                    child: IconButton(
                      onPressed: () => {},
                      icon: Icon(Icons.insert_drive_file),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    )
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextField(
                        controller: addressBarController,
                        focusNode: addressBarFocusNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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