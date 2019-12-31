import 'package:bubble/bubble.dart';
import 'package:chat_service/core/models/dao/multilist_item.dart';
import 'package:chat_service/ui/pages/conversation/widgets/message_item_builder/message_item_builder.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ConversationList extends StatelessWidget {

  List<MultilistItem> datas;
  AutoScrollController controller;
  bool showNewSeparator;
  int newSeparatorIndex;
  bool showGotoBottom;
  bool gotoBottom;

  ConversationList(this.datas, this.controller, {this.showNewSeparator = true, this.newSeparatorIndex = 1, this.showGotoBottom = false, this.gotoBottom = true});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _gotoNewMessage(context));
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: ListView.builder(
        controller: controller,
        itemCount: datas.length,
        reverse: true,
        itemBuilder: (context, index) {
          MultilistItem data = datas[index];
          if (data.type == "NEW_MESSAGE_SEPARATOR") {
            if (showNewSeparator) {
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
            else {
              return AutoScrollTag(
                  key: ValueKey(index),
                  controller: controller,
                  index: index,
                  child: Container(height: 0,)
              );
            }
          }
          return AutoScrollTag(
              key: ValueKey(index),
              controller: controller,
              index: index,
              child: MessageItemBuilder.builder(data)
          );
        },
      ),
    );
  }

  _gotoNewMessage(BuildContext context) {
    if (gotoBottom) {
      if (newSeparatorIndex > 0) {
        controller.scrollToIndex(
            newSeparatorIndex, preferPosition: AutoScrollPosition.end);
      }
    }
  }

}