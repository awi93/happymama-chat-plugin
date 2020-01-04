import 'package:chat_service/core/models/bases/base_model.dart';
import 'package:chat_service/core/models/tables/conversation_member.dart';
import 'package:chat_service/core/models/tables/media.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:equatable/equatable.dart';

class VwUserActiveConversation extends Equatable with BaseModel {

  String _id;
  String _conversationId;
  String _sourceMemberId;
  String _sourceMemberName;
  String _sourceMemberType;
  String _destinationMemberId;
  String _destinationMemberName;
  String _destinationMemberType;
  String _name;
  String _mediaId;
  String _latestMessageSenderId;
  String _latestMessage;
  String _latestMessageStatus;
  DateTime _latestMessageCreatedAt;
  String _type;
  Media _media;
  String _latestMessageType;
  bool _isExisting;
  List<ConversationMember> _conversationMembers;

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

  String get latestMessageType => _latestMessageType;

  set latestMessageType(String value) {
    _latestMessageType = value;
  }

  String get sourceMemberType => _sourceMemberType;

  set sourceMemberType(String value) {
    _sourceMemberType = value;
  }

  String get destinationMemberType => _destinationMemberType;

  set destinationMemberType(String value) {
    _destinationMemberType = value;
  }

  List<ConversationMember> get conversationMembers => _conversationMembers;

  set conversationMembers(List<ConversationMember> value) {
    _conversationMembers = value;
  }


  bool get isExisting => _isExisting;

  set isExisting(bool value) {
    _isExisting = value;
  }


  String get sourceMemberName => _sourceMemberName;

  set sourceMemberName(String value) {
    _sourceMemberName = value;
  }

  String get destinationMemberName => _destinationMemberName;

  set destinationMemberName(String value) {
    _destinationMemberName = value;
  }

  static VwUserActiveConversation fromJson (Map<String, dynamic> json) {
    VwUserActiveConversation data = new VwUserActiveConversation();

    data.id = json['id'];
    data.conversationId = json["conversation_id"];
    data.sourceMemberId = json["source_member_id"];
    data.sourceMemberName = json["source_member_name"];
    data.sourceMemberType = json["source_member_type"];
    data.destinationMemberId = json["destination_member_id"];
    data.destinationMemberName = json["destination_member_name"];
    data.destinationMemberType = json["destination_member_type"];
    data.name = json["name"];
    data.mediaId = json["media_id"];
    data.latestMessageSenderId = json["latest_message_sender_id"];
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