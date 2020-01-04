import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:chat_service/ui/widgets/miscs/ricebox_package_image.dart';
import 'package:flutter/material.dart';

class RiceboxPackage extends StatelessWidget {

  VwConversationMessage data;


  RiceboxPackage(this.data);

  @override
  Widget build(BuildContext context) {
    double oriPrice = double.parse(data.extras["price"]);
    double discount = double.parse(data.extras["discount"]);
    double price = oriPrice - (oriPrice * (discount/100));
    return Card(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              margin: EdgeInsets.only(right: 10),
              child: RiceboxPackageImage(data.extras["medias"]),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.extras["name"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
                Container(
                  height: 5,
                ),
                Builder(
                  builder: (context) {
                    if (discount > 0) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                            width: 40,
                            child: Text(Util.formatNumeric(Util.locale, discount) + "%", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).accentColor.withAlpha(100)
                            ),
                          ),
                          Container(
                            width: 10,
                          ),
                          Text(
                            Util.formatCurrency(Util.locale, oriPrice),
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[500],
                                fontSize: 12
                            ),
                          )
                        ],
                      );
                    }

                    return Container();
                  },
                ),
                Text(
                  (data.extras["type"] == "CATERING") ? Util.formatCurrency(Util.locale, price) + " per-Bulan" : (data.extras["type"] == "NASKOT") ? Util.formatCurrency(Util.locale, price) + " per-Hari" : (data.extras["type"] == "PO") ? Util.formatCurrency(Util.locale, price) + " per-Item" : "-",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).accentColor
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}