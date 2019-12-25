import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
import 'package:chat_service/ui/pages/active_conversation_list/bloc/active_conversation_list_event.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ActiveConversationListState {}

class InitialActiveConversationListState extends ActiveConversationListState {}

class FetchedState extends ActiveConversationListState {

  int _page = 0;
  bool _hasReachedFinal = false;
  List<VwUserActiveConversation> _datas;
  Map<String, String> _filter;

  FetchedState(this._page, this._hasReachedFinal, this._datas, this._filter);

  Map<String, String> get filter => _filter;

  List<VwUserActiveConversation> get datas => _datas;

  bool get hasReachedFinal => _hasReachedFinal;

  int get page => _page;

}

class ErrorState extends ActiveConversationListState {

  final ActiveConversationListState _prevState;
  final ActiveConversationListEvent _prevEvent;

  ErrorState(this._prevState, this._prevEvent);

  ActiveConversationListEvent get prevEvent => _prevEvent;

  ActiveConversationListState get prevState => _prevState;


}