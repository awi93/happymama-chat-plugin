import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_service/core/models/bases/paging.dart';
import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
import 'package:chat_service/core/repos/conversation_repo.dart';
import './bloc.dart';

class ActiveConversationListBloc extends Bloc<ActiveConversationListEvent, ActiveConversationListState> {
  @override
  ActiveConversationListState get initialState => InitialActiveConversationListState();

  @override
  Stream<ActiveConversationListState> mapEventToState(
    ActiveConversationListEvent event,
  ) async* {
    ActiveConversationListState state = currentState;
    if (state is ErrorState) {
      state = (state as ErrorState).prevState;
    }

    if (event is Refresh) {
      yield new InitialActiveConversationListState();
      dispatch(Fetch(event.memberId, event.query));
    }
    else if (event is Fetch) {
      bool fetch = (!_hasReachedMax(state));
      if (fetch) {
        try {
          event.query["paging"] = "6";
          if (state is InitialActiveConversationListState) {
            final Paging<VwUserActiveConversation> datas = await _fetch(event.memberId, page: 1, filter: event.query);
            yield new FetchedState(datas.currentPage, datas.currentPage == datas.lastPage, datas.data, event.query);
          }
          else if (state is FetchedState) {
            final Paging<VwUserActiveConversation> datas = await _fetch(event.memberId, page: state.page + 1, filter: event.query);
            yield new FetchedState(
                datas.currentPage,
                datas.currentPage == datas.lastPage,
                state.datas + datas.data,
                event.query
            );
          }
        }
        catch (e) {
          yield new ErrorState(state, event);
        }
      }
    }
    else if (event is Delete) {
      if (state is FetchedState) {
        try {
          ConversationRepo _conversationRepo = ConversationRepo.instance();
          await _conversationRepo
              .deleteActiveConversation(
              event.data.sourceMemberId, event.data.id);
          List<VwUserActiveConversation> datas = state.datas;
          datas.removeAt(event.index);
          yield new FetchedState(state.page, state.hasReachedFinal, datas, state.filter);
        }
        catch (e) {
          yield new ErrorState(state, event);
        }
      }
    }
  }

  bool _hasReachedMax(ActiveConversationListState state) =>
      state is FetchedState && state.hasReachedFinal;

  Future<Paging<VwUserActiveConversation>> _fetch(String memberId, {int page, Map<String, String> filter}) async {
    ConversationRepo _conversationRepo = ConversationRepo.instance();

    filter["page"] = page.toString();

    Paging<VwUserActiveConversation> datas = await _conversationRepo.fetchActiveConversations(memberId, query: filter);

    return datas;
  }
}