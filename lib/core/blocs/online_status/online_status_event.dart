import 'package:meta/meta.dart';

@immutable
abstract class OnlineStatusEvent {}

class Init extends OnlineStatusEvent {

  String _memberId;

  Init(this._memberId);

  String get memberId => _memberId;

}

class ChangeStatus extends OnlineStatusEvent {

  String _memberId;

  ChangeStatus(this._memberId);

  String get memberId => _memberId;

}