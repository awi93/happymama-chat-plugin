import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:chat_service/ui/widgets/message_item/custom_message/base_custom_message.dart';
import 'package:chat_service/ui/widgets/message_item/message_status.dart';
import 'package:flutter/material.dart';

class PlainText extends BaseCustomMessage {

  PlainText(VwConversationMessage data) : super(data);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      verticalDirection: VerticalDirection.down,
      alignment: WrapAlignment.end,
      children: <Widget>[
        SelectableText(
          data.message,
          style: TextStyle(
            fontSize: 16,
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

}