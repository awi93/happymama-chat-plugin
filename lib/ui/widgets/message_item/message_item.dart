import 'package:bubble/bubble.dart';
import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatefulWidget {

  final VwConversationMessage data;

  MessageItem(this.data, {Key key}) : super(key: key);

  _MessageItem createState() => _MessageItem(data);

}

class _MessageItem extends State<MessageItem> {

  final VwConversationMessage data;

  Alignment alignment;
  BubbleNip nipAlignment;
  Color backgroundColor;
  BubbleEdges bubbleMargin;

  _MessageItem(this.data);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (data.mode == "SOURCE") {
      alignment = Alignment.centerRight;
      backgroundColor = Color.fromRGBO(220, 248, 198, 1);
      if (data.isFirstOfGroup) {
        nipAlignment = BubbleNip.rightTop;
        bubbleMargin = BubbleEdges.only(top: 15, left: 60, right: 10);
      }
      else {
        bubbleMargin = BubbleEdges.only(top: 5, left: 60, right: 10);
      }
    }
    else {
      alignment = Alignment.centerLeft;
      backgroundColor = Colors.white;
      if (data.isFirstOfGroup) {
        nipAlignment = BubbleNip.leftTop;
        bubbleMargin = BubbleEdges.only(top: 15, right: 60, left: 10);
      }
      else {
        bubbleMargin = BubbleEdges.only(top: 5, right: 60, left: 10);
      }
    }
    if (data.isFirst) {
      bubbleMargin = BubbleEdges.only(top: bubbleMargin.top, right: bubbleMargin.right, left: bubbleMargin.left, bottom: 15);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Bubble(
        margin: bubbleMargin,
        padding: BubbleEdges.all(10),
        child: _buildMessage(),
        color: backgroundColor,
        nip: nipAlignment,
        nipWidth: 10,
      ),
    );
  }

  Widget _buildMessage() {
    return Util.factory.getWidget(data.type, data);
  }

}