import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageStatus extends StatelessWidget {

  String mode;
  String status;

  MessageStatus(this.mode, this.status);

  @override
  Widget build(BuildContext context) {
    if (mode == "DESTINATION") {
      return Container(height: 0,);
    }

    switch (status) {
      case "SENT" :
        return SizedBox(
          width: 14,
          height: 14,
          child: SvgPicture.asset(
            "packages/chat_service/assets/ic_sent.svg",
            color: Colors.grey,
          ),
        );
      case "DELIVERED":
        return SizedBox(
          width: 14,
          height: 14,
          child: SvgPicture.asset(
            "packages/chat_service/assets/ic_delivered_read.svg",
            color: Colors.grey,
          ),
        );
      case "READ":
        return SizedBox(
          width: 14,
          height: 14,
          child: SvgPicture.asset(
            "packages/chat_service/assets/ic_delivered_read.svg",
            color: Colors.lightBlue,
          ),
        );
    }
  }

}