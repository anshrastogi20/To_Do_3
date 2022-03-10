class Todo {
  int _id = 9999;
  String _title  = '';
  String _status = '';

  Todo(this._id,this._title,this._status);

  int get id => _id;
  String get title => _title;
  String get status => _status;

  set title(String newTitle) {
    if (newTitle.length<=100) {
      this._title = newTitle;
    }
  }
  set status(String newStatus) {
    this._status = newStatus;
  }

  // converting a Todo object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id!=null) {
      map['id'] = _id;
    }
    map['title']=_title;
    map['status']=_status;

    return map;
  }

  // extracting a Todo object from a Map object
  Todo.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._status = map['status'];
  }
}