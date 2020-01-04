import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:flutter/material.dart';

class RiceboxPackageImage extends StatelessWidget {

  List<Map<String, dynamic>> medias;

  RiceboxPackageImage(this.medias);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Builder(
      builder: (context) {
        String url = Util.remoteConfig.getString("sttn_url") + "/files/images/small/";
        for(Map<String, dynamic> media in this.medias) {
          if(media["metas"]["is_primary"] == true) {
            url += media["media"]["url"];
          }
        }
        return AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(5.0),
              child: CachedNetworkImage(
                placeholder: (context, url) {
                  return Container(
                    color: Colors.grey[200],
                  );
                },
                imageUrl: url,
              ),
            )
        );
      },
    );
  }

}