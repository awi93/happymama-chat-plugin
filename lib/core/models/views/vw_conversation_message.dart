import 'package:chat_service/core/models/bases/base_model.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:equatable/equatable.dart';

class VwConversationMessage extends Equatable with BaseModel {

  String _id;
  String _conversationId;
  String _senderId;
  String _replyTo;
  String _message;
  String _status;
  String _type;
  Map<String, dynamic> _extras;

  String mode;
  bool isFirstOfGroup;
  bool isFirst;

  String get id => _id;

  String get conversationId => _conversationId;

  String get senderId => _senderId;

  String get replyTo => _replyTo;

  String get message => _message;

  String get status => _status;

  Map<String, dynamic> get extras => _extras;

  set extras(Map<String, dynamic> value) {
    _extras = value;
  }

  set status(String value) {
    _status = value;
  }

  set message(String value) {
    _message = value;
  }

  set replyTo(String value) {
    _replyTo = value;
  }

  set senderId(String value) {
    _senderId = value;
  }

  set conversationId(String value) {
    _conversationId = value;
  }

  set id(String value) {
    _id = value;
  }

  String get type => _type;


  set type(String value) {
    _type = value;
  }


  static VwConversationMessage fromJson (Map<String, dynamic> json) {
    VwConversationMessage data = VwConversationMessage();

    data.id = json["id"];
    data.conversationId = json["conversation_id"];
    data.senderId = json["sender_id"];
    data.replyTo = json["reply_to"];
    data.message = json["message"];
    data.status = json["status"];
    data.type = json["type"];
    data.extras = json["extras"];
    data.createdAt = Util.millisToDatetime(json["created_at"]);
    data.updatedAt = Util.millisToDatetime(json["updated_at"]);
    data.createdBy = json["created_by"];
    data.updatedBy = json["updated_by"];

    return data;
  }

}