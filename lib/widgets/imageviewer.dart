import "package:flutter/material.dart";

class FullscreenImageViewer extends StatelessWidget {
  final ImageProvider image;
  const FullscreenImageViewer({ Key? key, required this.image }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image(image: image)),
        Positioned(
          child: Material(
            child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.close, color: Colors.white)),
            color: Colors.black54,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
            clipBehavior: Clip.antiAlias,
          ),
          top: 8, left: 8
        ),
      ],
    );
  }
}