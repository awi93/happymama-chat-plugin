import 'package:chat_service/core/models/bases/base_model.dart';

class ConversationMember extends BaseModel {

  String _conversationId;
  String _memberId;
  String _memberType;
  String _status;

  String get conversationId => _conversationId;

  set conversationId(String value) {
    _conversationId = value;
  }

  String get memberId => _memberId;

  set memberId(String value) {
    _memberId = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get memberType => _memberType;

  set memberType(String value) {
    _memberType = value;
  }


}