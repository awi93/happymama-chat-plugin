import 'package:equatable/equatable.dart';

class MultilistItem<T> extends Equatable {

  String type;
  T data;

  MultilistItem(this.type, this.data);

}