import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/ui/widgets/message_item/custom_message/link.dart';
import 'package:chat_service/ui/widgets/message_item/custom_message/media.dart';
import 'package:chat_service/ui/widgets/message_item/custom_message/plain_text.dart';
import 'package:chat_service/ui/widgets/message_item/custom_message/static_map.dart';
import 'package:chat_service/ui/widgets/message_item/custom_message/user_address.dart';
import 'package:flutter/material.dart';

class Factory {

  Widget getWidget (String type, VwConversationMessage data) {
    switch (type) {
      case "TEXT":
        return PlainText(data);
      case "STATIC_MAP":
        return StaticMap(data);
      case "USER_ADDRESS":
        return UserAddress(data);
      case "LINK":
        return Link(data);
      case "MEDIA":
        return Media(data);
    }
    return Text("UNKNOWN MESSAGE TYPE");
  }

}