import 'package:meta/meta.dart';

@immutable
abstract class OnlineStatusState {}

class InitialOnlineStatusState extends OnlineStatusState {}

class OnlineState extends OnlineStatusState {

  Map<String, dynamic> data;

  OnlineState(this.data);

}

class OfflineState extends OnlineStatusState {

  Map<String, dynamic> data;

  OfflineState(this.data);

}