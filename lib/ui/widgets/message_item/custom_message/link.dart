import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:chat_service/ui/widgets/message_item/custom_message/base_custom_message.dart';
import 'package:chat_service/ui/widgets/message_item/message_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Link extends BaseCustomMessage {

  Link(VwConversationMessage data) : super(data);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      verticalDirection: VerticalDirection.down,
      alignment: WrapAlignment.end,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _launchURL(data.extras["link"]);
          },
          behavior: HitTestBehavior.opaque,
          child: SelectableText(
            data.message,
            style: TextStyle(
              color: Colors.blue
            ),
          ),
        ),
        Container(
            width: 60,
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
            )
        )
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}