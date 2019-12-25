import 'package:chat_service/core/models/bases/base_model.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:equatable/equatable.dart';

class Media extends Equatable with BaseModel {

  String _id;
  DateTime _date;
  String _name;
  String _slug;
  String _description;
  String _url;
  String _mimeType;
  bool _status;
  String _ownerId;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get slug => _slug;

  set slug(String value) {
    _slug = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get mimeType => _mimeType;

  set mimeType(String value) {
    _mimeType = value;
  }

  bool get status => _status;

  set status(bool value) {
    _status = value;
  }

  String get ownerId => _ownerId;

  set ownerId(String value) {
    _ownerId = value;
  }

  static Media fromJson (Map<String, dynamic> json) {
    Media data = new Media();
    data.id = json["id"];
    data.date = Util.millisToDatetime(json["date"]);
    data.name = json["name"];
    data.slug = json["slug"];
    data.description = json["description"];
    data.url = json["url"];
    data.mimeType = json["mime_type"];
    data.status = json["status"];
    data.ownerId = json["owner_id"];
    data.createdAt = Util.millisToDatetime(json["created_at"]);
    data.updatedAt =  Util.millisToDatetime(json["updated_at"]);
    data.createdBy = json["created_by"];
    data.updatedBy =  json["updated_by"];

    return data;
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
    "id" : this.id,
    "date" : Util.datetimeToMillis(this.date),
    "name" : this.name,
    "slug" : this.slug,
    "description" : this.description,
    "url" : this.url,
    "mime_type" : this.mimeType,
    "status" : this.status,
    "owner_id" : this.ownerId,
    "created_at" : Util.datetimeToMillis(this.createdAt),
    "created_by" : this.createdBy,
    "updated_at" : Util.datetimeToMillis(this.updatedAt),
    "updated_by" : this.updatedBy
  };

}