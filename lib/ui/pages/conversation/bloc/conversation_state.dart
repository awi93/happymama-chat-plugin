import 'package:chat_service/core/models/dao/multilist_item.dart';
import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/ui/pages/conversation/bloc/bloc.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConversationState {}

class InitialConversationState extends ConversationState {}

class FetchedState extends ConversationState {

  int _page = 0;
  bool _hasReachedFinal = false;
  List<MultilistItem> _datas;
  List<VwConversationMessage> _rawDatas;
  Map<String, String> _filter;

  FetchedState(this._page, this._hasReachedFinal, this._datas, this._rawDatas,
      this._filter);

  Map<String, String> get filter => _filter;

  List<VwConversationMessage> get rawDatas => _rawDatas;

  List<MultilistItem> get datas => _datas;

  bool get hasReachedFinal => _hasReachedFinal;

  int get page => _page;

}

class ErrorState extends ConversationState {

  final ConversationState _prevState;
  final ConversationEvent _prevEvent;

  ErrorState(this._prevState, this._prevEvent);

  ConversationEvent get prevEvent => _prevEvent;

  ConversationState get prevState => _prevState;


}