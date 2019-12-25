class BaseModel {

  DateTime _createdAt;
  DateTime _updatedAt;
  String _createdBy;
  String _updatedBy;

  DateTime get createdAt => _createdAt;

  DateTime get updatedAt => _updatedAt;

  String get createdBy => _createdBy;

  String get updatedBy => _updatedBy;

  set updatedBy(String value) {
    _updatedBy = value;
  }

  set createdBy(String value) {
    _createdBy = value;
  }

  set updatedAt(DateTime value) {
    _updatedAt = value;
  }

  set createdAt(DateTime value) {
    _createdAt = value;
  }
  
}