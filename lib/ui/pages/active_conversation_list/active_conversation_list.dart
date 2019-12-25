import 'package:chat_service/ui/pages/active_conversation_list/bloc/active_conversation_list_bloc.dart';
import 'package:chat_service/ui/pages/active_conversation_list/bloc/bloc.dart';
import 'package:chat_service/ui/widgets/conversation_item/conversation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ActiveConversationList extends StatefulWidget {

  final String _memberId;

  ActiveConversationList(this._memberId);

  @override
  _ActiveConversationList createState() => _ActiveConversationList(_memberId);

}

class _ActiveConversationList extends State<ActiveConversationList> {

  final String _memberId;
  final Map<String, String> queries = {
    "paging" : "6",
    "media" : "1",
    "status" : "ACTIVE"
  };

  final _scrollThreshold = 100.0;

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final _scrollController = ScrollController();

  BuildContext _context;

  ActiveConversationListBloc _bloc;

  _ActiveConversationList(this._memberId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController.addListener(_onScroll);
    _bloc =  new ActiveConversationListBloc();
    _bloc.state.listen((state) {
      if (state is ErrorState) {
        final snackBar = SnackBar(
          action: SnackBarAction(
            label: "Coba Lagi",
            onPressed: () {
              _bloc.dispatch(state.prevEvent);
            },
          ),
          content: Text("Oops!! Sepertinya Anda bermasalah dengan jaringan. Silahkan coba kembali"),
          duration: Duration(hours: 9999999),
        );
        Scaffold.of(_context).showSnackBar(snackBar);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat"
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.filter,
              color: Colors.grey[700],
            ),
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          this._context = context;
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: MaterialClassicHeader(),
            onRefresh: _onRefresh,
            controller: _refreshController,
            child: BlocProvider(
              builder: (context) => _bloc,
              child: BlocBuilder(
                bloc: _bloc..dispatch(Fetch(_memberId, queries)),
                builder: (context, state) {
                  if (state is ErrorState) {
                    state = (state as ErrorState).prevState;
                  }
                  if (state is InitialActiveConversationListState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else if (state is FetchedState) {
                    if (state.datas.length > 0) {
                      return ListView.builder(
                        itemCount: (state.hasReachedFinal) ? state.datas.length : state.datas.length + 1,
                        itemBuilder: (context, index) {
                          if (index < state.datas.length) {
                            return ConversationItem(index, state.datas[index]);
                          }
                          else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    }
                    else {
                      return Container(
                        padding: EdgeInsets.all(50),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 180,
                              height: 180,
                              child: Image(
                                image: AssetImage(
                                    "packages/chat_service/assets/ic_no_conversation.png"
                                ),
                              ),
                            ),
                            Container(
                              height: 20,
                            ),
                            Text(
                              "Belum ada chat dari penjual",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              height: 5,
                            ),
                            Text(
                              "Yuk mulai percakapan dengan penjual, Anda bisa bertanya tentang menu atau jangkauan dari toko",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600]
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      );
                    }
                  }
                  return Container();
                },
              ),
            )
          );
        },
      ),
    );
  }


  void _onRefresh() async {
    _bloc.dispatch(Refresh(_memberId, queries));
    _refreshController.refreshCompleted();
  }


  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _bloc.dispatch(Fetch(_memberId, queries));
    }
  }


}