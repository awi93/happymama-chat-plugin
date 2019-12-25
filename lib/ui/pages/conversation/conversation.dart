import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:chat_service/ui/pages/conversation/bloc/bloc.dart';
import 'package:chat_service/ui/pages/conversation/conversation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Conversation extends StatefulWidget {

  final VwUserActiveConversation data;

  Conversation(this.data);

  @override
  _Conversation createState() => _Conversation(data);

}


class _Conversation extends State<Conversation>{

  final VwUserActiveConversation data;
  final Map<String, String> query = {
    "paging" : "40",
    "order_by" : "[created_at:desc]",
  };
  int newIndex = 0;

  ConversationBloc _bloc;

  _Conversation(this.data);

  @override
  void initState() {
    // TODO: implement initState
    _bloc = new ConversationBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              child: Stack(
                children: <Widget>[
                  Container(
                      height: 55,
                      width: 55,
                      child: Builder(
                        builder: (context) {
                          if (data.media != null) {
                            return CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  Util.remoteConfig.getString("static_url") + "/files/images/small/" + data.media.url
                              ),
                              backgroundColor: Colors.grey[300],
                            );
                          }
                          else {
                            String assets = "packages/chat_service/assets/ic_user.png";
                            if (data.type == 'GROUP') {
                              assets = "packages/chat_service/assets/ic_users.png";
                            }
                            return CircleAvatar(
                              backgroundImage: AssetImage(
                                  assets
                              ),
                              backgroundColor: Colors.grey[300],
                            );
                          }
                        },
                      )
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(
                      FontAwesomeIcons.solidCircle,
                      size: 10,
                      color: Colors.grey[600],
                    )
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16
                      ),
                    ),
                    Container(
                      height: 5,
                    ),
                    Text(
                      "Terakhir online 1 Jam yang lalu",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: BlocBuilder(
                  bloc: _bloc..dispatch(Fetch(data.sourceMemberId, data.conversationId, this.query)),
                  builder: (context, state) {
                    if (state is ErrorState) {
                      state = (state as ErrorState).prevState;
                    }
                    if (state is InitialConversationState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else if (state is FetchedState) {
                      newIndex = state.datas.indexWhere((data) => data.type == "NEW_MESSAGE_SEPARATOR");
                      return ConversationList(state.datas);
                    }
                    return Container();
                  },
                )
              ),
              Container(
                height: 65,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 5, left: 10),
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey[500])
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      child : SvgPicture.asset(
                        "packages/chat_service/assets/ic_send.svg",
                        color: Colors.white,
                        width: 20,
                        height: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffea4f1c),
                        borderRadius:  BorderRadius.circular(25)
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white
                ),
              )
            ],
          ),
          color: Color.fromRGBO(236, 229, 221, 1),
        ),
      )
    );
  }

}