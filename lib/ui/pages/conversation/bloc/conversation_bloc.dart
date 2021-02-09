import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chat_service/core/models/bases/cud_response.dart';
import 'package:chat_service/core/models/bases/paging.dart';
import 'package:chat_service/core/models/dao/multilist_item.dart';
import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
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
    ConversationState state = this.state;
    if (state is ErrorState) {
      state = (state as ErrorState).prevState;
    }

    if (event is Fetch) {
      bool fetch = (!_hasReachedMax(state));
      if (fetch) {
        try {
          if (state is InitialConversationState) {
            if (event.conversation.conversationId != null) {
              final Paging<VwConversationMessage> items = await _fetch(
                  event.conversation.sourceMemberId,
                  event.conversation.conversationId, page: 1,
                  filter: event.query);
              yield new ActivedState(
                event.conversation,
                items.currentPage, items.currentPage == items.lastPage,
                items.data,
                buildDatas(items.data, event.conversation.sourceMemberId),
                event.query, "FETCH");
            }
            else {
              ConversationRepo _conversationRepo = ConversationRepo.instance();
              CUDResponse<VwUserActiveConversation> response = await _conversationRepo.saveConversation(event.conversation.sourceMemberId, event.conversation);
              VwUserActiveConversation data = response.data;
              if (data.isExisting) {
                final Paging<VwConversationMessage> items = await _fetch(
                    data.sourceMemberId,
                    data.conversationId, page: 1,
                    filter: event.query);
                List<MultilistItem> datas = buildDatas(items.data, data.sourceMemberId);
                yield new ActivedState(
                  data,
                  items.currentPage,
                  items.currentPage == items.lastPage,
                  items.data,
                  datas,
                  event.query, "FETCH");
              }
              else {
                yield new ActivedState(
                  data,
                  1,
                  true,
                  [],
                  buildDatas([], data.sourceMemberId),
                  event.query, "FETCH");
              }
            }
          }
          else if (state is ActivedState) {
            final Paging<VwConversationMessage> items = await _fetch(event.conversation.sourceMemberId, event.conversation.conversationId,  page: state.page + 1, filter: event.query);
            yield new ActivedState(
              event.conversation,
              items.currentPage,
              items.currentPage == items.lastPage,
              state.rawDatas + items.data,
              buildDatas(state.rawDatas + items.data, event.conversation.sourceMemberId),
              event.query,
              "LOAD_MORE"
            );
          }
        }
        catch (e) {
          yield new ErrorState(state, event);
        }
      }
    }
    else if (event is Receive) {
      if (state is ActivedState) {
        if (event.type == "NEW") {
          List<VwConversationMessage> rawDatas = state.rawDatas;
          rawDatas.insert(0, event.message);
          yield new ActivedState(state.conversation, state.page, state.hasReachedFinal, rawDatas, buildDatas(rawDatas, event.conversation.sourceMemberId), state.query, "RECEIVE");
        }
        else {
          List<VwConversationMessage> rawDatas = state.rawDatas;
          for (VwConversationMessage data in rawDatas) {
            if (data.id == event.message.id) {
              data.status = event.message.status;
            }
          }
          yield new ActivedState(state.conversation, state.page, state.hasReachedFinal, rawDatas, buildDatas(rawDatas, event.conversation.sourceMemberId), state.query, "UPDATE_STATUS");
        }
      }
    }
    else if (event is Send) {
      if (state is ActivedState) {
        ConversationRepo.instance().pushMessage(event.message);
        List<VwConversationMessage> rawDatas = state.rawDatas;
        rawDatas.insert(0, event.message);
        yield new ActivedState(state.conversation, state.page, state.hasReachedFinal, rawDatas,
            buildDatas(rawDatas, event.conversation.sourceMemberId),
            state.query, "SEND");
      }
    }
    else if (event is MarkAsRead) {
      if (state is ActivedState) {
        for (MultilistItem item in state.datas) {
          if (item.type == "ITEM") {
            if ((item.data as VwConversationMessage).status != "READ" && ((item.data as VwConversationMessage)).mode == "DESTINATION") {
              ConversationRepo.instance().pushMessageStatus((item.data as VwConversationMessage), event.conversation.sourceMemberId, "READ");
            }
          }
        }
        yield new ActivedState(state.conversation, state.page, state.hasReachedFinal, state.rawDatas, state.datas, state.query, "READ");
      }
    }
  }

  bool _hasReachedMax(ConversationState state) =>
      state is ActivedState && state.hasReachedFinal;

  Future<Paging<VwConversationMessage>> _fetch(String memberId, String conversationId, {int page, Map<String, String> filter}) async {
    ConversationRepo _conversationRepo = ConversationRepo.instance();

    filter["page"] = page.toString();

    Paging<VwConversationMessage> items = await _conversationRepo.fetchConversationMessages(memberId, conversationId, query: filter);

    return items;
  }

  List<MultilistItem> buildDatas (List<VwConversationMessage> rawDatas, String memberId) {
    final Map<String, List<VwConversationMessage>> dateGrouped = groupBy(rawDatas, (d) => Util.formatDate(Util.MONTH_DAY_YEAR, d.createdAt));
    final Map<String, Map<String, List<VwConversationMessage>>> finalGrouped = new Map();

    try {
      for (String date in dateGrouped.keys) {
        final Map<String, List<VwConversationMessage>> group = new Map();
        group["UNREAD"] = [];
        int index = 0;
        for (int i = 0; i < dateGrouped[date].length; i ++) {
          VwConversationMessage data = dateGrouped[date][i];
          VwConversationMessage nextData = (i < dateGrouped[date].length - 1)
              ? dateGrouped[date][i + 1]
              : null;

          if (data.senderId != memberId)
            data.mode = "DESTINATION";
          else
            data.mode = "SOURCE";

          data.isFirstOfGroup = false;
          data.isFirst = false;

          if (i == dateGrouped[date].length - 1) {
            data.isFirstOfGroup = true;
          }

          if (nextData != null) {
            if (nextData.senderId != data.senderId) {
              data.isFirstOfGroup = true;

              if (group.containsKey(index.toString())) {
                group[index.toString()].add(data);
              }
              else {
                group[index.toString()] = [];
                group[index.toString()].add(data);
              }

              index += 1;
            }
            else {
              if (group.containsKey(index.toString())) {
                group[index.toString()].add(data);
              }
              else {
                group[index.toString()] = [];
                group[index.toString()].add(data);
              }
            }
          }
          else {
            if (group.containsKey(index.toString())) {
              group[index.toString()].add(data);
            }
            else {
              group[index.toString()] = [];
              group[index.toString()].add(data);
            }
          }
        }

        finalGrouped[date] = group;
      }
    }
    catch(e) {
      print(e);
    }

    List<MultilistItem> datas = [];

    for (String date in finalGrouped.keys) {
      for (String group in finalGrouped[date].keys) {
        datas.addAll(finalGrouped[date][group].map((data) => new MultilistItem("ITEM", data)));
      }
      datas.add(new MultilistItem("HEADER", date));
    }

    if (datas.length > 0) {
      if (datas[0].type == "ITEM")
        datas[0].data.isFirst = true;
    }

    int lastIdex = -1;
    for (int i = 0; i < datas.length; i++) {
      MultilistItem data = datas[i];
      if (data.type == "ITEM") {
        VwConversationMessage msg = data.data;
        if (msg.status != "READ" && msg.mode == "DESTINATION") {
          lastIdex = i;
        }
        else {
          break;
        }
      }
    }

    if (lastIdex >= 0) {
      datas.insert(lastIdex + 1, new MultilistItem("NEW_MESSAGE_SEPARATOR", null));
    }

    datas.add(new MultilistItem("FOOTER", null));

    return datas;
  }

}
