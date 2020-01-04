import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmbeddedMessage extends StatefulWidget {

  ValueChanged<VwConversationMessage> valueChanged;
  VwUserActiveConversation conversation;

  EmbeddedMessage(this.valueChanged, this.conversation);

  @override
  _EmbeddedMessage createState() => _EmbeddedMessage(valueChanged, conversation);

}

class _EmbeddedMessage extends State<EmbeddedMessage> {

  ValueChanged<VwConversationMessage> valueChanged;
  VwUserActiveConversation conversation;

  _EmbeddedMessage(this.valueChanged, this.conversation);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 200,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Lampirkan Pesan Khusus",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
              Container(
                height: 15,
              ),
              Container(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Util.embeddedMessagePickers.length,
                  itemBuilder: (context, index) {
                    Util.embeddedMessagePickers[index].conversation = conversation;
                    Util.embeddedMessagePickers[index].valueChanged = valueChanged;
                    return Util.embeddedMessagePickers[index];
                  },
                ),
              )
            ],
          )
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            behavior: HitTestBehavior.opaque,
            child: Icon(
              FontAwesomeIcons.timesCircle
            ),
          ),
        )
      ],
    );
  }

}