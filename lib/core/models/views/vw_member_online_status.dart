import 'package:chat_service/core/utils/util.dart';

class VwMemberOnlineStatus {

  String _memberId;
  DateTime _ping;

  String get memberId => _memberId;

  DateTime get ping => _ping;

  set ping(DateTime value) {
    _ping = value;
  }

  set memberId(String value) {
    _memberId = value;
  }

  static VwMemberOnlineStatus fromJson (Map<String, dynamic> json) {
    VwMemberOnlineStatus data = new VwMemberOnlineStatus();
    data.memberId = json["member_id"];
    data.ping = Util.millisToDatetime(json["ping"]);
    return data;
  }

}