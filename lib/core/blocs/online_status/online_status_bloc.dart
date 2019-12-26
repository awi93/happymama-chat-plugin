import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_service/core/repos/conversation_repo.dart';
import 'package:chat_service/core/services/online_status/online_status.dart';
import './bloc.dart';

class OnlineStatusBloc extends Bloc<OnlineStatusEvent, OnlineStatusState> {
  Timer timer;

  @override
  OnlineStatusState get initialState => InitialOnlineStatusState();

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
        dispatch(ChangeStatus(event.memberId));
      });
      try {
        Map<String, dynamic> data = await OnlineStatus.getOnlineStatus(event.memberId);
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
    // TODO: implement dispose
    super.dispose();

    timer?.cancel();
  }
}
