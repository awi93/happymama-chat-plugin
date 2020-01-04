import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:flutter/material.dart';

class UserAddress extends StatelessWidget {

  String _longitude;
  String _latitude;
  String _size = "640x640";
  String _zoom = "20";

  VwConversationMessage data;

  UserAddress(this.data);

  @override
  Widget build(BuildContext context) {
    this._latitude = data.extras["latitude"];
    this._longitude = data.extras["longitude"];
    var baseUri = new Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        port: 443,
        path: '/maps/api/staticmap',
        queryParameters: {
          'size': this._size,
          'center': this._latitude + "," + this._longitude,
          'zoom': this._zoom,
          'key' : '${Util.GOOGLE_API_KEY}',
          'markers' : this._latitude + "," + this._longitude
        });
    // TODO: implement build
    return Card(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              margin: EdgeInsets.only(right: 10),
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.extras["name"] + " (" + data.extras["contact_person"] + "- " + data.extras["phone_no"] + ")",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  Text(
                    data.extras["address"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12
                    ),
                    softWrap: false,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}