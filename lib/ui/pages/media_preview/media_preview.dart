import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MediaPreview extends StatelessWidget {

  final String _url;

  MediaPreview(this._url);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.0,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            iconSize: 30,
          ),
        ),
        body: Container(
          color: Colors.black,
          child: PhotoView(
            imageProvider: CachedNetworkImageProvider(_url),
          )
        )
    );
  }

}