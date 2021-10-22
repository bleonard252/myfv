import "package:flutter/material.dart";

class ErrorScreen extends StatelessWidget {
  final Widget icon;
  final Widget title;
  final List<Widget> text;
  final Widget errorCode;
  const ErrorScreen({
    Key? key,
    this.icon = const Icon(Icons.warning),
    this.title = const Text("Error loading page"),
    this.text = const [Text("There was an error loading the page."), Text("Try again later.")],
    this.errorCode = const Text("UNKNOWN ERROR")
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          //alignment: Alignment.center,
          width: 720,
          padding: EdgeInsets.all(36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: IconTheme(
                  data: IconThemeData(size: 36),
                  child: icon
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline4!,
                  child: title
                )
              ),
              for (var entry in text) Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyText2!,
                  child: entry
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.overline!,
                  child: errorCode
                )
              ),
            ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        ),
      ),
    );
  }
}