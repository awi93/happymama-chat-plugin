import 'package:equatable/equatable.dart';

class Paging<T> extends Equatable {

  int _currentPage;
  int _from;
  int _to;
  int _perPage;
  int _total;
  int _lastPage;
  String _firstPageUrl;
  String _lastPageUrl;
  String _nextPageUrl;
  String _prevPageUrl;
  String _path;
  List<T> _data;

  int get currentPage => _currentPage;

  set currentPage(int value) {
    _currentPage = value;
  }

  int get from => _from;

  set from(int value) {
    _from = value;
  }

  List<T> get data => _data;

  set data(List<T> value) {
    _data = value;
  }

  String get path => _path;

  set path(String value) {
    _path = value;
  }

  String get prevPageUrl => _prevPageUrl;

  set prevPageUrl(String value) {
    _prevPageUrl = value;
  }

  String get nextPageUrl => _nextPageUrl;

  set nextPageUrl(String value) {
    _nextPageUrl = value;
  }

  String get lastPageUrl => _lastPageUrl;

  set lastPageUrl(String value) {
    _lastPageUrl = value;
  }

  String get firstPageUrl => _firstPageUrl;

  set firstPageUrl(String value) {
    _firstPageUrl = value;
  }

  int get lastPage => _lastPage;

  set lastPage(int value) {
    _lastPage = value;
  }

  int get total => _total;

  set total(int value) {
    _total = value;
  }

  int get perPage => _perPage;

  set perPage(int value) {
    _perPage = value;
  }

  int get to => _to;

  set to(int value) {
    _to = value;
  }

  Paging(this._currentPage, this._from, this._to, this._perPage, this._total,
      this._lastPage, this._firstPageUrl, this._lastPageUrl, this._nextPageUrl,
      this._prevPageUrl, this._path, this._data);

}