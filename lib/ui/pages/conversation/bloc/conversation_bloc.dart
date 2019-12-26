import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_service/core/models/bases/paging.dart';
import 'package:chat_service/core/models/dao/multilist_item.dart';
import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/repos/conversation_repo.dart';
import 'package:chat_service/core/utils/util.dart';
import './bloc.dart';
import 'package:collection/collection.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  @override
  ConversationState get initialState => InitialConversationState();

  @override
  Stream<ConversationState> mapEventToState(
    ConversationEvent event,
  ) async* {
    ConversationState state = currentState;
    if (state is ErrorState) {
      state = (state as ErrorState).prevState;
    }

    if (event is Fetch) {
      bool fetch = (!_hasReachedMax(state));
      if (fetch) {
        try {
          if (state is InitialConversationState) {
            final Paging<VwConversationMessage> items = await _fetch(event.memberId, event.conversationId,  page: 1, filter: event.query);
            yield new FetchedState(items.currentPage, items.currentPage == items.lastPage, getitems(items.data, event.memberId), items.data, event.query);
          }
          else if (state is FetchedState) {
            final Paging<VwConversationMessage> items = await _fetch(event.memberId, event.conversationId, page: state.page + 1, filter: event.query);
            yield new FetchedState(
                items.currentPage,
                items.currentPage == items.lastPage,
                getitems(state.rawDatas + items.data, event.memberId),
                state.rawDatas + items.data,
                event.query
            );
          }
        }
        catch (e) {
          yield new ErrorState(state, event);
        }
      }
    }
  }

  List<MultilistItem> getitems (List<VwConversationMessage> raw, String memberId) {
    Map<String, List<VwConversationMessage>> grouped = groupBy(raw, (d) => Util.formatDate(Util.MONTH_DAY_YEAR, d.createdAt));
    List<MultilistItem> items = List();

    for (String group in grouped.keys) {
      items.addAll(grouped[group].map((a) => new MultilistItem("ITEM", a)));
      items.add(new MultilistItem("HEADER", group));
    }

    int lasti = 0;
    for(int i = 0; i < items.length; i++) {
      if (items[i].type == "ITEM") {
        items[i].data.isFirstOfGroup = false;
        items[i].data.isFirst = (i == 0);

        if (items[i].data.memberId != memberId) {
          items[i].data.mode = "DESTINATION";
        }
        else {
          items[i].data.mode = "SOURCE";
        }

        if ((i + 1) > items.length) {
          items[i].data.isFirstOfGroup = true;
        }
        else {
          if (items[i + 1].type == "HEADER") {
            items[i].data.isFirstOfGroup = true;
          }
          else
          if (items[i + 1].data.senderId !=
              items[i].data.senderId) {
            items[i].data.isFirstOfGroup = true;
          }
        }
      }
    }

    for(int i = 0; i < items.length; i++) {
      if (items[i].type == "ITEM") {
        if (items[i].data.status != "READ" &&
            items[i].data.memberId != memberId) {
          lasti = i;
        }
        else {
          break;
        }
      }
    }

    if (lasti > 0) {
      items.insert(lasti, new MultilistItem("NEW_MESSAGE_SEPARATOR", null));
    }

    items.add(new MultilistItem("FOOTER", null));

    return items;
  }

  bool _hasReachedMax(ConversationState state) =>
      state is FetchedState && state.hasReachedFinal;

  Future<Paging<VwConversationMessage>> _fetch(String memberId, String conversationId, {int page, Map<String, String> filter}) async {
    ConversationRepo _conversationRepo = ConversationRepo.instance();

    filter["page"] = page.toString();

    Paging<VwConversationMessage> items = await _conversationRepo.fetchConversationMessages(memberId, conversationId, query: filter);

    return items;
  }
}
