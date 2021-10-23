import "package:flutter/material.dart";
import 'package:myfv/parse/data.dart';
import 'package:myfv/widgets/imageviewer.dart';

extension RenderBasicMyfileCard on BasicMyfileCard {
  Widget render() => Builder(builder: (context) => Card(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (this.title != null) Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(this.title!, maxLines: null, style: TextStyle(fontWeight: FontWeight.bold))
        ),
        if (this.text != null) Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(this.text!, maxLines: null)
        ),
        if (this.image != null) Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: Image(image: this.image!, width: double.infinity, fit: BoxFit.fitWidth),
            onTap: () => showDialog(context: context, builder: (_) => FullscreenImageViewer(image: this.image!)),
          ),
        )
      ],
    ),
  ));
}