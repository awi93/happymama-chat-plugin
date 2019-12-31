import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConversationEvent {}

class Fetch extends ConversationEvent {

  VwUserActiveConversation conversation;
  Map<String, String> query;

  Fetch(this.conversation, this.query);

}

class Receive extends ConversationEvent {

  VwUserActiveConversation conversation;
  VwConversationMessage message;
  String type;

  Receive(this.conversation, this.message, this.type);


}

class Send extends ConversationEvent {

  VwUserActiveConversation conversation;
  VwConversationMessage message;

  Send(this.conversation, this.message);

}

class MarkAsRead extends ConversationEvent {

  VwUserActiveConversation conversation;

  MarkAsRead(this.conversation);

}