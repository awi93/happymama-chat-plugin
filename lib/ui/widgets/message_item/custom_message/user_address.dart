import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:chat_service/ui/widgets/message_item/custom_message/base_custom_message.dart';
import 'package:chat_service/ui/widgets/message_item/message_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAddress extends BaseCustomMessage {

  UserAddress(VwConversationMessage data) : super(data);

  String _longitude;
  String _latitude;
  String _size = "640x640";
  String _zoom = "20";
  final String _defaultLatitude = "3.597031";
  final String _defaultLongitude = "98.678513";

  @override
  Widget build(BuildContext context) {
    if (data.extras['latitude'] != null) {
      _latitude = data.extras["latitude"];
    }
    else {
      _latitude = _defaultLatitude;
    }

    if (data.extras['longitude'] != null) {
      _longitude = data.extras["longitude"];
    }
    else {
      _longitude = _defaultLongitude;
    }
    var baseUri = new Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        port: 443,
        path: '/maps/api/staticmap',
        queryParameters: {
          'size': this._size,
          'center': this._latitude + "," + this._longitude,
          'zoom': this._zoom,
          'key': '${Util.GOOGLE_API_KEY}',
          'markers': this._latitude + "," + this._longitude
        });

    return Container(
      width: 260,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            data.extras["name"],
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          Container(
            height: 5,
          ),
          Text(
            data.extras["contact_person"] + " - " + data.extras["phone_no"],
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          Container(
            height: 5,
          ),
          Text(data.extras["address"]),
          Text("Note: " + data.extras["address_desc"]),
          Container(
            height: 10,
          ),
          Stack(
            children: <Widget>[
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    image: DecorationImage(
                        image: NetworkImage(
                          baseUri.toString(),
                        ),
                        fit: BoxFit.fitWidth
                    )
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 70,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        Util.formatDate(Util.HOUR_MINUTE, data.createdAt),
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14
                        ),
                      ),
                      Container(
                        width: 5,
                      ),
                      MessageStatus(data.mode, data.status)
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}