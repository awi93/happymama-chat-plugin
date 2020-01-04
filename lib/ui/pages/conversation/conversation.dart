import 'dart:core';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:chat_service/ui/pages/conversation/bloc/bloc.dart';
import 'package:chat_service/ui/pages/conversation/widgets/conversation_appbar.dart';
import 'package:chat_service/ui/pages/conversation/widgets/conversation_list.dart';
import 'package:chat_service/ui/pages/conversation/widgets/embedded_message.dart';
import 'package:chat_service/ui/widgets/embedded_message_item/factory.dart';
import 'package:chat_service/ui/widgets/embedded_message_picker/embedded_message_picker.dart';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:uuid/uuid.dart';

class Conversation extends StatefulWidget {

  final VwUserActiveConversation conversation;
  final String memberExchangeRoute;
  final VwConversationMessage embeddedMessage;

  Conversation(this.conversation, this.memberExchangeRoute, {this.embeddedMessage});

  _Conversation createState() => _Conversation(conversation, memberExchangeRoute, this.embeddedMessage);

}

class _Conversation extends State<Conversation> with WidgetsBindingObserver {

  final _scrollThreshold = 100.0;

  VwUserActiveConversation conversation;
  final String memberExchangeRoute;
  VwConversationMessage embeddedMessage;

  final Map<String, String> query = {
    "paging" : "40",
    "order_by" : "[created_at:desc]",
  };

  final AutoScrollController controller = AutoScrollController();
  final TextEditingController textController = TextEditingController();

  bool showGotoBottom = false;
  String displayState = "FOREGROUND";
  ConversationBloc _bloc;
  Client client;

  _Conversation(this.conversation, this.memberExchangeRoute, this.embeddedMessage);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initChannel();

    _bloc = ConversationBloc();

    controller.addListener(_onScroll);

    WidgetsBinding.instance.addObserver(this);

    Util.prefs.setString("ACTIVE_CONVERSATION", conversation.conversationId);

    _bloc.state.listen((state) {
      if (state is ActivedState) {
        int newIndex = state.datas.indexWhere((data) => data.type == "NEW_MESSAGE_SEPARATOR");

        if (newIndex > 0) {
          if (state.state == "RECEIVE") {
            if (controller.offset > 100) {
              setState(() {
                showGotoBottom = true;
              });
            }
            else {
              if (this.displayState == "FOREGROUND") {
                _bloc.dispatch(MarkAsRead(conversation));
              }
            }
          }
        }

        if (state.state == "SEND") {
          setState(() {
            showGotoBottom = false;
          });
        }

        if (state.state == "FETCH") {
          _bloc.dispatch(MarkAsRead(state.conversation));
        }

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: ConversationAppbar(conversation),
          backgroundColor: Colors.white,
        ),
        body: BlocProvider(
          builder: (context) => _bloc,
          child: SafeArea(
            child: Container(
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 90,
                    child: Stack(
                      children: <Widget>[
                        BlocBuilder(
                          bloc: _bloc..dispatch(Fetch(conversation, query)),
                          builder: (context, state) {
                            if (state is ErrorState) {
                              state = (state as ErrorState).prevState;
                            }
                            if (state is InitialConversationState) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            else if (state is ActivedState) {
                              this.conversation = state.conversation;
                              int newIndex = state.datas.indexWhere((data) => data.type == "NEW_MESSAGE_SEPARATOR");
                              bool showNewSeparator = false;
                              bool gotoBottom = true;

                              if (state.state == "FETCH" || state.state == "LOAD_MORE") {
                                showNewSeparator = true;
                              }
                              else if (state.state == "RECEIVE") {
                                gotoBottom = false;
                                if (this.displayState == "BACKGROUND")
                                  showNewSeparator = true;

                                if (controller.offset > 100)
                                  showNewSeparator = true;
                              }
                              else if (state.state == "READ") {
                                showNewSeparator = false;
                              }

                              if (state.state == "SEND") {
                                newIndex = 0;
                                showNewSeparator = false;
                              }

                              if (state.state == "LOAD_MORE" || state.state == "READ") {
                                gotoBottom = false;
                              }

                              return ConversationList(state.datas, controller, newSeparatorIndex: newIndex, showNewSeparator: showNewSeparator, gotoBottom: gotoBottom,);
                            }
                            return Container();
                          },
                        ),
                        Builder(
                          builder: (context) {
                            if (showGotoBottom) {
                              return Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (controller != null)
                                        controller.scrollToIndex(0, duration: Duration(seconds: 2));
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        FontAwesomeIcons.arrowAltCircleDown,
                                        color: Colors.grey[500],
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.grey[500]),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors
                                                    .grey
                                                    .withAlpha(
                                                    80),
                                                offset: Offset(
                                                    2, 2),
                                                blurRadius: 1)
                                          ]
                                      ),
                                    ),
                                  )
                              );
                            }
                            return Container();
                          },
                        )
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Column(
                        children: <Widget>[
                          Builder(
                            builder: (context) {
                              if (embeddedMessage != null) {
                                return Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 80,
                                      width: MediaQuery.of(context).size.width,
                                      child: Factory.getWidget(embeddedMessage.type, embeddedMessage),
                                      color: Colors.white,
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            embeddedMessage = null;
                                          });
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Icon(
                                          FontAwesomeIcons.timesCircle,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(context: context, builder: (context) => EmbeddedMessage((VwConversationMessage data) {
                                      if (data.type == "MEDIA") {
                                        Uuid uuid = new Uuid();
                                        data.id = uuid.v4();
                                        data.conversationId =
                                            conversation.conversationId;
                                        data.senderId =
                                            conversation.sourceMemberId;
                                        data.createdAt = DateTime.now();
                                        data.status = "ON_PROGRESS";
                                        _bloc.dispatch(Send(conversation, data));
                                      }
                                      else {
                                        setState(() {
                                          this.embeddedMessage = data;
                                        });
                                      }
                                      Navigator.of(context).pop();
                                    }, conversation));
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    child: Icon(
                                      FontAwesomeIcons.plus,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 0),
                                      child: TextField(
                                        minLines: 1,
                                        maxLines: 3,
                                        controller: textController,
                                        decoration: InputDecoration(
                                            hintText: "Masukan Sebuah Pesan",
                                            hintStyle: TextStyle(color: Colors.black26),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey[600].withAlpha(80), width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey[600].withAlpha(100), width: 1),
                                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)
                                        ),
                                      ),
                                    )
                                ),
                                Container(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    sendMessage();
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    padding: EdgeInsets.all(11),
                                    child: SvgPicture.asset(
                                      "packages/chat_service/assets/ic_send.svg",
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Theme.of(context).accentColor
                                    ),
                                  ),
                                )
                              ],
                            ),
                            color: Colors.white,
                            alignment: Alignment.center,
                          ),
                        ],
                      )
                    ),
                    constraints: BoxConstraints(
                      minHeight: 60,
                      maxHeight: 240
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(236, 229, 221, 1),
              ),
            ),
          ),
        )
    );
  }

  Future<void> initChannel() async {

    client = new Client(
      settings: ConnectionSettings(
        host: Util.remoteConfig.getString("amqp_url"),
        authProvider: AmqPlainAuthenticator(Util.RABBIT_USERNAME, Util.RABBIT_PASSWORD)
      )
    );

    Channel channel = await client.channel();

    Exchange exchange = await channel.exchange("member." + memberExchangeRoute, ExchangeType.FANOUT);

    Uuid uuid = Uuid();
    String randomUuid = uuid.v4();
    Queue queue = await channel.queue(randomUuid, exclusive: true);
    queue.bind(exchange, null);

    Consumer consumer = await queue.consume();
    consumer.listen((AmqpMessage message) {
      Map<String, dynamic> data = message.payloadAsJson;
      switch (data["type"]) {
        case "MESSAGE" :
          VwConversationMessage  message = VwConversationMessage.fromJson(data["data"]);
          if (displayState == "BACKGROUND") {
            FlutterRingtonePlayer.playNotification();
          }
          else {
            Audio.load("packages/chat_service/assets/notif.mp3")..play()..dispose();
          }
          _bloc.dispatch(Receive(conversation, message, "NEW"));
          break;
        case "MSG_STATUS_UPDATE" :
          VwConversationMessage  message = VwConversationMessage.fromJson(data["data"]);
          if (message.status == "DELIVERED" && message.senderId == conversation.sourceMemberId)
            Audio.load("packages/chat_service/assets/tick.mp3")..play()..dispose();
          _bloc.dispatch(Receive(conversation, message, "UPDATE_STATUS"));
          break;
      }
    });

  }

  Future<void> sendMessage() async {
    if (_bloc.currentState is ActivedState) {
      SystemChannels.textInput.invokeMethod(
          'TextInput.hide');
      if (textController.text != null &&
          textController.text != "") {
        Uuid uuid = new Uuid();
        if (embeddedMessage != null) {
          embeddedMessage.id = uuid.v4();
          embeddedMessage.conversationId =
              conversation.conversationId;
          embeddedMessage.senderId =
              conversation.sourceMemberId;
          embeddedMessage.createdAt =
          DateTime.now()..subtract(Duration(microseconds: 10));
          embeddedMessage.status =
          "ON_PROGRESS";
          _bloc.dispatch(Send(
              conversation, embeddedMessage));
          setState(() {
            embeddedMessage = null;
          });

        }
        VwConversationMessage message = new VwConversationMessage();
        message.id = uuid.v4();
        message.conversationId =
            conversation.conversationId;
        message.senderId =
            conversation.sourceMemberId;
        message.message = textController.text;
        message.status = "ON_PROGRESS";
        message.type = "TEXT";
        message.createdAt = DateTime.now();
        textController.clear();
        await Future.delayed(Duration(milliseconds: 300),() {});
        _bloc.dispatch(
            Send(conversation, message));
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      this.displayState = "BACKGROUND";
    }
    else if (state == AppLifecycleState.resumed) {
      this.displayState = "FOREGROUND";
      if (controller.offset < 100) {
        _bloc.dispatch(MarkAsRead(conversation));
      }
    }
    print(this.displayState);
  }

  void _onScroll() {
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _bloc.dispatch(Fetch(conversation, query));
    }
    if (controller.offset < 100) {
      setState(() {
        showGotoBottom = false;
      });
      if (this.displayState == "FOREGROUND") {
        _bloc.dispatch(MarkAsRead(conversation));
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    client.close();
    Util.prefs.remove("ACTIVE_CONVERSATION");
  }

}
