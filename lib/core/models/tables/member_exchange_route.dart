import 'package:chat_service/core/models/bases/base_model.dart';
import 'package:chat_service/core/utils/util.dart';

class MemberExchangeRoute extends BaseModel {

  int _id;
  String _memberId;
  String _routeId;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get memberId => _memberId;

  set memberId(String value) {
    _memberId = value;
  }

  String get routeId => _routeId;

  set routeId(String value) {
    _routeId = value;
  }

  static MemberExchangeRoute fromJson (Map<String, dynamic> json) {
    MemberExchangeRoute data = new MemberExchangeRoute();
    data.id = json["id"];
    data.memberId = json["member_id"];
    data.routeId = json["route_id"];
    data.createdAt = Util.millisToDatetime(json["created_at"]);
    data.updatedAt =  Util.millisToDatetime(json["updated_at"]);
    data.createdBy = json["created_by"];
    data.updatedBy =  json["updated_by"];
  }

}