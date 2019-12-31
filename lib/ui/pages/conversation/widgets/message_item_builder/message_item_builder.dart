import 'package:bubble/bubble.dart';
import 'package:chat_service/core/models/dao/multilist_item.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:chat_service/ui/widgets/message_item/message_item.dart';
import 'package:flutter/material.dart';

class MessageItemBuilder {

  static Widget builder(MultilistItem data) {
    switch (data.type) {
      case "ITEM" :
        return MessageItem(data.data, key: new Key(data.data.id));
      case "HEADER" :
        String today = Util.formatDate(Util.MONTH_DAY_YEAR, DateTime.now());
        String label = data.data;
        if (label == today)
          label = "Hari ini";
        return Bubble(
          stick: true,
          margin: BubbleEdges.only(top: 15),
          alignment: Alignment.center,
          color: Color.fromRGBO(212, 234, 244, 1.0),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.0)),
        );
      case "FOOTER" :
        return Padding(
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
        );
    }

    return Container();
  }

}