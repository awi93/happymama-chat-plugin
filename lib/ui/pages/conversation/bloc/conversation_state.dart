import 'package:chat_service/core/models/dao/multilist_item.dart';
import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
import 'package:chat_service/ui/pages/conversation/bloc/bloc.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConversationState {}

class InitialConversationState extends ConversationState {}

class ActivedState extends ConversationState {

  VwUserActiveConversation conversation;
  int page = 0;
  bool hasReachedFinal = false;
  List<VwConversationMessage> rawDatas;
  List<MultilistItem> datas;
  Map<String, String> query;
  String state;

  ActivedState(this.conversation, this.page, this.hasReachedFinal,
      this.rawDatas, this.datas, this.query, this.state);


}

class ErrorState extends ConversationState {

  ConversationState prevState;
  ConversationEvent prevEvent;

  ErrorState(this.prevState, this.prevEvent);

}