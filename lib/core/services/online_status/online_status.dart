import 'dart:async';

import 'package:chat_service/core/models/views/vw_member_online_status.dart';
import 'package:chat_service/core/repos/conversation_repo.dart';

class OnlineStatus {

  static Timer _timer;

  static void startPing (String memberId) {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _sendPing(memberId));
  }

  static void stopPing () {
    if (_timer != null)
      _timer.cancel();
  }

  static void _sendPing(String memberId) {
    ConversationRepo.instance().saveMemberOnlineStatus(memberId);
  }

  static Future<Map<String, dynamic>> getOnlineStatus (String memberId) async {
    VwMemberOnlineStatus status = await ConversationRepo.instance().fetchMemberOnlineStatus(memberId);
    DateTime now = DateTime.now();
    Duration diff = now.difference(status.ping);
    if (diff.inSeconds > 90) {
      return {
        "status" : "OFFLINE",
        "last" : diff
      };
    }

    return {
      "status" : "ONLINE",
      "last" : diff
    };
  }

}