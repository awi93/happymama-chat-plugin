import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
import 'package:flutter/cupertino.dart';

abstract class EmbeddedMessagePicker extends StatelessWidget {

  ValueChanged<VwConversationMessage> valueChanged;
  VwUserActiveConversation conversation;

}