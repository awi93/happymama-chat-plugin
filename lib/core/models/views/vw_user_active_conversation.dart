import 'package:chat_service/core/models/bases/base_model.dart';
import 'package:chat_service/core/models/tables/media.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:equatable/equatable.dart';

class VwUserActiveConversation extends Equatable with BaseModel {

  String _id;
  String _conversationId;
  String _sourceMemberId;
  String _destinationMemberId;
  String _name;
  String _mediaId;
  String _latestMessageSenderId;
  String _latestMessageMemberId;
  String _latestMessage;
  String _latestMessageStatus;
  DateTime _latestMessageCreatedAt;
  String _type;
  Media _media;
  String _latestMessageType;

  String get id => _id;

  String get conversationId => _conversationId;

  String get sourceMemberId => _sourceMemberId;

  String get destinationMemberId => _destinationMemberId;

  String get name => _name;

  String get mediaId => _mediaId;

  String get latestMessageSenderId => _latestMessageSenderId;

  String get latestMessage => _latestMessage;

  String get latestMessageStatus => _latestMessageStatus;

  DateTime get latestMessageCreatedAt => _latestMessageCreatedAt;

  String get type => _type;

  Media get media => _media;

  set media(Media value) {
    _media = value;
  }

  set type(String value) {
    _type = value;
  }

  set latestMessageCreatedAt(DateTime value) {
    _latestMessageCreatedAt = value;
  }

  set latestMessageStatus(String value) {
    _latestMessageStatus = value;
  }

  set latestMessage(String value) {
    _latestMessage = value;
  }

  set latestMessageSenderId(String value) {
    _latestMessageSenderId = value;
  }

  set mediaId(String value) {
    _mediaId = value;
  }

  set name(String value) {
    _name = value;
  }

  set destinationMemberId(String value) {
    _destinationMemberId = value;
  }

  set sourceMemberId(String value) {
    _sourceMemberId = value;
  }

  set conversationId(String value) {
    _conversationId = value;
  }

  set id(String value) {
    _id = value;
  }


  String get latestMessageMemberId => _latestMessageMemberId;

  set latestMessageMemberId(String value) {
    _latestMessageMemberId = value;
  }


  String get latestMessageType => _latestMessageType;

  set latestMessageType(String value) {
    _latestMessageType = value;
  }

  static VwUserActiveConversation fromJson (Map<String, dynamic> json) {
    VwUserActiveConversation data = new VwUserActiveConversation();

    data.id = json['id'];
    data.conversationId = json["conversation_id"];
    data.sourceMemberId = json["source_member_id"];
    data.destinationMemberId = json["destination_member_id"];
    data.name = json["name"];
    data.mediaId = json["media_id"];
    data.latestMessageSenderId = json["latest_message_sender_id"];
    data.latestMessageMemberId = json["latest_message_member_id"];
    data.latestMessage = json["latest_message"];
    data.latestMessageStatus = json["latest_message_status"];
    data.latestMessageType = json["latest_message_type"];
    data.latestMessageCreatedAt = Util.millisToDatetime(json["latest_message_created_at"]);
    data.type = json["type"];
    data.media = (json['media'] != null) ? Media.fromJson(json['media']) : null;
    data.createdAt = Util.millisToDatetime(json["created_at"]);
    data.updatedAt = Util.millisToDatetime(json["updated_at"]);
    data.createdBy = json["created_by"];
    data.updatedBy = json["updated_by"];

    return data;
  }

}