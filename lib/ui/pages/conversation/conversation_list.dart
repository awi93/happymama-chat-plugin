import 'package:bubble/bubble.dart';
import 'package:chat_service/core/models/dao/multilist_item.dart';
import 'package:chat_service/ui/widgets/message_item/message_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ConversationList extends StatefulWidget {

  final List<MultilistItem> datas;

  ConversationList(this.datas);

  _ConversationList createState() => _ConversationList(datas);

}

class _ConversationList extends State<ConversationList> {

  final List<MultilistItem> datas;

  int newSeparatorIndex;

  _ConversationList(this.datas);

  AutoScrollController controller = new AutoScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _gotoNewMessage(context));
  }

  _gotoNewMessage(BuildContext context) {
    if (newSeparatorIndex != null) {
      controller.scrollToIndex(newSeparatorIndex, preferPosition: AutoScrollPosition.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    newSeparatorIndex = datas.indexWhere((d) => d.type == "NEW_MESSAGE_SEPARATOR");
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: ListView.builder(
        reverse: true,
        itemCount: datas.length,
        controller: controller,
        itemBuilder: (context, index) {
          if (index < datas.length && index >= 0) {
            if (datas[index].type == "ITEM") {
              return AutoScrollTag(
                  key: ValueKey(index),
                  controller: controller,
                  index: index,
                  child: MessageItem(datas[index].data,
                      key: new Key(datas[index].data.id))
              );
            }
            else if (datas[index].type == "NEW_MESSAGE_SEPARATOR") {
              return AutoScrollTag(
                key: ValueKey(index),
                controller: controller,
                index: index,
                child: Bubble(
                  margin: BubbleEdges.only(top: 15),
                  padding: BubbleEdges.symmetric(
                      horizontal: 25, vertical: 10),
                  radius: Radius.circular(100),
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Text(
                    "Pesan Baru",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0)),
                )
              );
            }
            else if (datas[index].type == "HEADER") {
              return AutoScrollTag(
                key: ValueKey(index),
                controller: controller,
                index: index,
                child: Bubble(
                  stick: true,
                  margin: BubbleEdges.only(top: 15),
                  alignment: Alignment.center,
                  color: Color.fromRGBO(212, 234, 244, 1.0),
                  child: Text(
                    datas[index].data,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.0)),
                )
              );
            }
            else if (datas[index].type == "FOOTER") {
              return AutoScrollTag(
                key: ValueKey(index),
                controller: controller,
                index: index,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.warning,
                          color: Colors.yellow[700],
                          size: 40,
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Mohon berhati-hati bila pengguna lain meminta Anda berkomunikasi dan bertransaksi diluar Happymama.",
                                    style: TextStyle(
                                        color: Colors.grey[700]
                                    )
                                )
                              ]
                          ),
                        ),
                      )
                    ],
                  ),
                )
              );
            }
          }

          return Container();
        },
      ),
    );
  }

}