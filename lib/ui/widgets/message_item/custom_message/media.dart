import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:chat_service/ui/pages/media_preview/media_preview.dart';
import 'package:chat_service/ui/widgets/message_item/custom_message/base_custom_message.dart';
import 'package:chat_service/ui/widgets/message_item/message_status.dart';
import 'package:flutter/material.dart';

class Media extends BaseCustomMessage {


  Media(VwConversationMessage data) : super(data);

  @override
  Widget build(BuildContext context) {
    String url = Util.remoteConfig.getString("static_url") + "/files/images/large/" + data.extras["url"];
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MediaPreview(url),
              settings: RouteSettings(
                name: "media-preview"
              )
            ));
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        url
                    ),
                    fit: BoxFit.fitWidth
                )
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 70,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(top: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  Util.formatDate(Util.HOUR_MINUTE, data.createdAt),
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14
                  ),
                ),
                Container(
                  width: 5,
                ),
                MessageStatus(data.mode, data.status)
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white
            ),
          ),
        )
      ],
    );
  }

}