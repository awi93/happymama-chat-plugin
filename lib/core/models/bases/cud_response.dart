import 'package:equatable/equatable.dart';

class CUDResponse<T> extends Equatable {

  String _id;
  T _data;

  CUDResponse(this._id, this._data);

  T get data => _data;

  String get id => _id;

}