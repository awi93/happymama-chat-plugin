import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:chat_service/core/services/online_status/online_status.dart';
import 'package:chat_service/core/utils/util.dart';
import './bloc.dart';

class OnlineStatusBloc extends Bloc<OnlineStatusEvent, OnlineStatusState> {
  Timer timer;

  @override
  OnlineStatusState get initialState => _getInitialState();

  OnlineStatusState _getInitialState() {
    String onlineStatus = Util.prefs.getString("ONLINE_STATUS");

    if (onlineStatus != null) {
      Map<String, dynamic> json = jsonDecode(onlineStatus);

      if (json["status"] == "ONLINE") {
        return OnlineState(json);
      }
      else {
        return OfflineState(json);
      }
    }

    return InitialOnlineStatusState();
  }

  @override
  Stream<OnlineStatusState> mapEventToState(
    OnlineStatusEvent event,
  ) async* {
    if (event is Init) {
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
      timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
        add(ChangeStatus(event.memberId));
      });
      try {
        Map<String, dynamic> data = await OnlineStatus.getOnlineStatus(event.memberId);
        Util.prefs.setString("ONLINE_STATUS", jsonEncode(data));
        if (data["status"] == "ONLINE") {
          yield new OnlineState(data);
        }
        else {
          yield new OfflineState(data);
        }
      }
      catch (e) {
        yield new OfflineState({
          "status" : "OFFLINE",
          "last" : null
        });
      }
    }
    else if (event is ChangeStatus) {
      try {
        Map<String, dynamic> data = await OnlineStatus.getOnlineStatus(event.memberId);
        Util.prefs.setString("ONLINE_STATUS", jsonEncode(data));
        if (data["status"] == "ONLINE") {
          yield new OnlineState(data);
        }
        else {
          yield new OfflineState(data);
        }
      }
      catch (e) {
        yield new OfflineState({
          "status" : "OFFLINE",
          "last" : null
        });
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
  }
}
