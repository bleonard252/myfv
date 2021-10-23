import "package:flutter/material.dart";
import 'package:myfv/parse/data.dart';
import 'package:myfv/widgets/imageviewer.dart';

class MyfileHeaderSection extends StatelessWidget {
  final ParsedMyfileData myfile;
  const MyfileHeaderSection({ Key? key, required this.myfile }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          if (myfile.banner != null) InkWell(
            child: Image(image: myfile.banner!, height: 128, width: double.infinity, fit: BoxFit.fitWidth),
            onTap: () => showDialog(context: context, builder: (_) => FullscreenImageViewer(image: myfile.banner!)),
          ),
          if (myfile.image != null || myfile.name != null || myfile.nickname != null) Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (myfile.image != null) Padding(
                padding: const EdgeInsets.all(8.0),
                child: DecoratedBox(
                  position: DecorationPosition.foreground,
                  child: InkWell(
                    child: Image(image: myfile.image!, height: 64, width: 64, fit: BoxFit.cover),
                    onTap: () => showDialog(context: context, builder: (_) => FullscreenImageViewer(image: myfile.image!))
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.25),
                      style: BorderStyle.solid,
                      width: 2
                    )
                  ),
                ),
              ),
              if ((myfile.nickname ?? myfile.name) != null) Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text((myfile.nickname ?? myfile.name)!,
                    style: Theme.of(context).textTheme.headline6,
                    maxLines: null
                  ),
                ),
              ),
            ],
          ),
          if (myfile.description != null) Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(myfile.description!, maxLines: null),
          )
        ],
      ),
    );
  }
}