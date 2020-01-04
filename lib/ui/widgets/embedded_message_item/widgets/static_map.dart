import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:flutter/material.dart';

class StaticMap extends StatelessWidget {

  String _longitude;
  String _latitude;
  String _size = "640x640";
  String _zoom = "20";

  VwConversationMessage data;

  StaticMap(this.data);

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
                    data.extras["address"],
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14
                    ),
                    softWrap: true,
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