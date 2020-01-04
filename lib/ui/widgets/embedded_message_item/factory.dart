

import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/ui/widgets/embedded_message_item/widgets/ricebox_package.dart';
import 'package:chat_service/ui/widgets/embedded_message_item/widgets/ricebox_package_purchase.dart';
import 'package:chat_service/ui/widgets/embedded_message_item/widgets/static_map.dart';
import 'package:chat_service/ui/widgets/embedded_message_item/widgets/user_address.dart';
import 'package:flutter/material.dart';

class Factory {

  static Widget getWidget (String type, VwConversationMessage data) {
    switch (type) {
      case "STATIC_MAP":
        return StaticMap(data);
      case "USER_ADDRESS":
        return UserAddress(data);
      case "RICEBOX_PACKAGE":
        return RiceboxPackage(data);
      case "RICEBOX_PACKAGE_PURCHASE":
        return RiceboxPackagePurchase(data);
    }
    return Text("UNKNOWN MESSAGE TYPE");
  }

}