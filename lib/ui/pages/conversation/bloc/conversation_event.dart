import 'package:meta/meta.dart';

@immutable
abstract class ConversationEvent {}

class Fetch extends ConversationEvent {

  String memberId;
  String conversationId;
  Map<String, String> query;

  Fetch(this.memberId, this.conversationId, this.query);

}