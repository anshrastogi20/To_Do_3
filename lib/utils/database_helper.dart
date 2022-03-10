import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_3/models/todo.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;            //Singleton
  static Database? _database;                        //Singleton
  //static DatabaseHelper _databaseHelper;            //Singleton
  //static Database _database;                        //Singleton


  String todoTable = 'todo_table';
  String colId  = 'id';
  String coltitle = 'title';
  String colstatus = 'status';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() =>
      _databaseHelper ??= DatabaseHelper._createInstance();
  /*
  factory DatabaseHelper(){
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  */
/*
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }
  */
  Future<Database> get database async =>
    _database ??= await initializeDatabase();


  Future<Database> initializeDatabase() async {
    //Getting the directory path to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todo.db';

    var todoDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    print('jyfhtgrwrrhtyukio;kojlhgfdrfsefrdgtfyuio;iiuytresfdghjklmnbvcxzcvbnm,mnbgfdsadfghjkljhtrewqertyuiop');
    return todoDatabase;
  }

  void _createDb(Database db,int newVersion) async {

    await db.execute('CREATE TABLE $todoTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $coltitle TEXT, $colstatus TEXT)');
    print('created the table');
  }

  // Fetching all todo objects to database
  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $todoTable');
    var result = await db.query(todoTable);
    return result;
  }
  // Get the 'Map List' and convert it to 'Todo List'
  Future<List<Todo>> getTodoList() async {
    var todoMapList = await getTodoMapList();
    int count = todoMapList.length;

    List<Todo> todolist = <Todo>[];
    for (int i=0;i<count;i++) {
      todolist.add(Todo.fromMapObject(todoMapList[i]));
    }
    return todolist;

  }

  // Insert a todo object to database
  Future<int> insertTodo(Todo todo) async {
    Database db = await this.database;
    print("i a before delete");
    Future<int> i = deleteTodo(9999);
    print("I am bfr insert");
    var result = await db.insert(todoTable, todo.toMap());
    print("I am afr insert");
    return result;
  }
  // Update a todo object and save it to database
  Future<int> updateTodo(Todo todo) async {
    Database db = await this.database;
    int result = await db.update(todoTable, todo.toMap(), where: '$colId = ?', whereArgs: [todo.id]);
    return result;
  }
  // Delete a todo object from database
  Future<int> deleteTodo(int id) async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $todoTable where $colId = $id');
    return result;
  }
  // Count of number of todo objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $todoTable');
    //int result = Sqflite.firstIntValue(x);
    int result = 4;
    return result;
  }
}