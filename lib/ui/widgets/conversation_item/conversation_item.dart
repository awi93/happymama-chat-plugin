import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:chat_service/ui/pages/active_conversation_list/bloc/active_conversation_list_bloc.dart';
import 'package:chat_service/ui/pages/active_conversation_list/bloc/active_conversation_list_event.dart';
import 'package:chat_service/ui/pages/conversation/conversation.dart';
import 'package:chat_service/ui/widgets/message_item/message_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConversationItem extends StatefulWidget {

  final int index;
  final VwUserActiveConversation data;
  final String _memberExchangeRoute;

  ConversationItem(this.index, this.data, this._memberExchangeRoute);

  _ConversationItem createState() => _ConversationItem(index, data, _memberExchangeRoute);

}

class _ConversationItem extends State<ConversationItem> {

  final int index;
  final VwUserActiveConversation data;
  final String _memberExchangeRoute;


  _ConversationItem(this.index, this.data, this._memberExchangeRoute);

  Color backgroundColors = Colors.white;
  ActiveConversationListBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = BlocProvider.of<ActiveConversationListBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          backgroundColors = Colors.white;
        });
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isDismissible: false,
          builder: (context) {
            return Container(
              height: 180,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: GestureDetector(
                        child: Icon(
                          FontAwesomeIcons.times,
                          color: Colors.grey[700],
                          size: 24,
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    GestureDetector(
                      onTap: () {
                        _bloc.add(Delete(data, index));
                        Navigator.of(context).pop();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              size: 24,
                              color: Colors.grey[600],
                            ),
                            Container(
                              width: 20,
                            ),
                            Text(
                              "Hapus Percakapan",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
              ),
            );
          }
        );
      },
      onLongPressStart: (LongPressStartDetails d) {
        setState(() {
          backgroundColors = Colors.blue.withAlpha(50);
        });
      },
      onLongPressEnd: (LongPressEndDetails d) {
        setState(() {
          backgroundColors = Colors.white;
        });
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Conversation(data, _memberExchangeRoute),
            settings: RouteSettings(
                name: "conversation"
            )
        ));
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: <Widget>[
            Container(
                height: 55,
                width: 55,
                child: Builder(
                  builder: (context) {
                    if (data.media != null) {
                      return CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          Util.remoteConfig.getString("sttn_url") + "/files/images/small/" + data.media.url
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
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                      ),
                    ),
                    Container(
                      height: 5,
                    ),
                    _latestMessage()
                  ],
                ),
              ),
            ),
            Container(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Util.formatDate(Util.HOUR_MINUTE, data.latestMessageCreatedAt),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  Builder(
                    builder: (context) {
                      if (data.latestMessageStatus != "READ" && data.latestMessageSenderId != data.sourceMemberId) {
                        return Icon(
                          FontAwesomeIcons.solidCircle,
                          color: Colors.red,
                          size: 8,
                        );
                      }

                      return Container(
                        height: 8,
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: backgroundColors
        ),
      ),
    );
  }

  Widget _latestMessage() {
    switch (data.latestMessageType) {
      case "TEXT":
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Builder(
              builder: (context) {
                if (data.latestMessageSenderId == data.sourceMemberId) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MessageStatus(
                          (data.latestMessageSenderId != data.sourceMemberId)
                              ? "DESTINATION"
                              : "SOURCE", data.latestMessageStatus),
                      Container(
                        width: 10,
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
            Text(
              data.latestMessage,
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        );
      case "RICEBOX_PACKAGE" :
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[

            Builder(
              builder: (context) {
                if (data.latestMessageSenderId == data.sourceMemberId) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MessageStatus(
                          (data.latestMessageSenderId != data.sourceMemberId)
                              ? "DESTINATION"
                              : "SOURCE", data.latestMessageStatus),
                      Container(
                        width: 10,
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
            Icon(
              FontAwesomeIcons.box,
              color: Colors.grey[700],
              size: 16,
            ),
            Container(
              width: 5,
            ),
            Text(
              "Paket Menu",
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        );
      case "RICEBOX_PACKAGE_PURCHASE" :
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Builder(
              builder: (context) {
                if (data.latestMessageSenderId == data.sourceMemberId) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MessageStatus(
                          (data.latestMessageSenderId != data.sourceMemberId)
                              ? "DESTINATION"
                              : "SOURCE", data.latestMessageStatus),
                      Container(
                        width: 10,
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
            Icon(
              FontAwesomeIcons.fileInvoice,
              color: Colors.grey[700],
              size: 16,
            ),
            Container(
              width: 5,
            ),
            Text(
              "Invoice Pembelian",
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        );
      case "PARTNER" :
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Builder(
              builder: (context) {
                if (data.latestMessageSenderId == data.sourceMemberId) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MessageStatus(
                          (data.latestMessageSenderId != data.sourceMemberId)
                              ? "DESTINATION"
                              : "SOURCE", data.latestMessageStatus),
                      Container(
                        width: 10,
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
            Icon(
              FontAwesomeIcons.store,
              color: Colors.grey[700],
              size: 16,
            ),
            Container(
              width: 5,
            ),
            Text(
              "Toko",
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        );
      case "MEDIA" :
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Builder(
              builder: (context) {
                if (data.latestMessageSenderId == data.sourceMemberId) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MessageStatus(
                          (data.latestMessageSenderId != data.sourceMemberId)
                              ? "DESTINATION"
                              : "SOURCE", data.latestMessageStatus),
                      Container(
                        width: 10,
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
            Icon(
              FontAwesomeIcons.camera,
              color: Colors.grey[700],
              size: 16,
            ),
            Container(
              width: 5,
            ),
            Text(
              "Gambar",
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        );
      case "LINK" :
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Builder(
              builder: (context) {
                if (data.latestMessageSenderId == data.sourceMemberId) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MessageStatus(
                          (data.latestMessageSenderId != data.sourceMemberId)
                              ? "DESTINATION"
                              : "SOURCE", data.latestMessageStatus),
                      Container(
                        width: 10,
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
            Icon(
              FontAwesomeIcons.link,
              color: Colors.grey[700],
              size: 16,
            ),
            Container(
              width: 5,
            ),
            Text(
              data.latestMessage,
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        );
      case "STATIC_MAP" :
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Builder(
              builder: (context) {
                if (data.latestMessageSenderId == data.sourceMemberId) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MessageStatus(
                          (data.latestMessageSenderId != data.sourceMemberId)
                              ? "DESTINATION"
                              : "SOURCE", data.latestMessageStatus),
                      Container(
                        width: 10,
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
            Icon(
              FontAwesomeIcons.mapPin,
              color: Colors.grey[700],
              size: 16,
            ),
            Container(
              width: 5,
            ),
            Text(
              "Pinpoint Peta",
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        );
      case "USER_ADDRESS" :
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Builder(
              builder: (context) {
                if (data.latestMessageSenderId == data.sourceMemberId) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MessageStatus(
                          (data.latestMessageSenderId != data.sourceMemberId)
                              ? "DESTINATION"
                              : "SOURCE", data.latestMessageStatus),
                      Container(
                        width: 10,
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
            Icon(
              FontAwesomeIcons.ribbon,
              color: Colors.grey[700],
              size: 16,
            ),
            Container(
              width: 5,
            ),
            Text(
              "Alamat Pengguna",
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        );
    }

    return Container();
  }

}