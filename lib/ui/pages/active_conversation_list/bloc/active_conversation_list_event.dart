import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ActiveConversationListEvent {}

class Fetch extends ActiveConversationListEvent {

  final String memberId;
  final Map<String, String> query;

  Fetch(this.memberId, this.query);

}

class Refresh extends ActiveConversationListEvent {

  final String memberId;
  final Map<String, String> query;

  Refresh(this.memberId, this.query);

}

class Delete extends ActiveConversationListEvent {

  final VwUserActiveConversation data;
  final int index;

  Delete(this.data, this.index);

}

class UpdateLatestMessage extends ActiveConversationListEvent {

  final VwConversationMessage data;

  UpdateLatestMessage(this.data);

}

class UpdateLatestMessageStatus extends ActiveConversationListEvent {

  final VwConversationMessage data;

  UpdateLatestMessageStatus(this.data);

}