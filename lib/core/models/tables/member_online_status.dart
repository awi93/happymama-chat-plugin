import 'package:chat_service/core/utils/util.dart';

class MemberOnlineStatus {

  int _id;
  String _memberId;
  DateTime _ping;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get memberId => _memberId;

  DateTime get ping => _ping;

  set ping(DateTime value) {
    _ping = value;
  }

  set memberId(String value) {
    _memberId = value;
  }

  static MemberOnlineStatus fromJson (Map<String, dynamic> json) {
    MemberOnlineStatus data = new MemberOnlineStatus();
    data.id = json["id"];
    data.memberId = json["member_id"];
    data.ping = Util.millisToDatetime(json["ping"]);
    return data;
  }

}