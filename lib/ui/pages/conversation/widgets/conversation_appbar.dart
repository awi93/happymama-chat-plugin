import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:chat_service/ui/widgets/online_status/online_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationAppbar extends StatelessWidget {

  VwUserActiveConversation conversation;

  ConversationAppbar(this.conversation);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          child: Stack(
            children: <Widget>[
              Container(
                  height: 55,
                  width: 55,
                  child: Builder(
                    builder: (context) {
                      if (conversation.media != null) {
                        return CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              Util.remoteConfig.getString("static_url") + "/files/images/small/" + conversation.media.url
                          ),
                          backgroundColor: Colors.grey[300],
                        );
                      }
                      else {
                        String assets = "packages/chat_service/assets/ic_user.png";
                        if (conversation.type == 'GROUP') {
                          assets = "packages/chat_service/assets/ic_users.png";
                        }
                        return CircleAvatar(
                          backgroundImage: AssetImage(
                              assets
                          ),
                          backgroundColor: Colors.grey[300],
                        );
                      }
                    },
                  )
              )
            ],
          ),
        ),
        Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    conversation.name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  OnlineStatus(conversation.destinationMemberId)
                ],
              ),
            )
        )
      ],
    );
  }

}