import 'package:flutter/material.dart';
import 'dart:async';
import 'package:to_do_3/models/todo.dart';
import 'package:to_do_3/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(Mytodo());
}

class Mytodo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'To-Do',
        debugShowCheckedModeBanner: false,
        home: Todolist());
  }
}
class Todolist extends StatefulWidget {
  @override
  TodoListState createState() {
    return TodoListState();
  }
}
class TodoListState extends State<Todolist> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList = [];
  int count = 0;
  static Todo todo = Todo(9999,"","");
  //Todo todo;
  TextEditingController titleController = TextEditingController();
  //TextEditingController statusController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    if (todoList == null) {
      todoList = <Todo>[];
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(title: Text("To-Do")),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          alertbox(context);
        },
        tooltip: 'Add a To-Do',
        child: Icon(Icons.add),
      ),
    );
  }
  ListView getListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.arrow_forward_ios_outlined),
              title: Text(this.todoList[position].title,style: TextStyle(fontSize: 30.0)),
              subtitle: Text(this.todoList[position].status,style: TextStyle(fontSize: 10.0)),
              trailing: RaisedButton(
                  color: Colors.green,
                  child: Text(
                      "Completed",
                      style: TextStyle(
                          color: Colors.white
                      )
                  ),
                  onPressed: () {
                    _delete(context, todoList[position]);
                  }
              ),
            ),
          );
        }
    );
  }

  void alertbox(context) {
    var alert = AlertDialog(
      title: Text("Add a new To-Do"),
      content: TextField(
        controller: titleController,
        decoration: const InputDecoration(hintText: "Enter Task here"),
      ),
      actions: <Widget>[
        RaisedButton(
          child: Text(
            "Add",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            //databaseHelper.insertTodo(todo);
            _save();
            //addItem(controller.text);
          },
        ),
        RaisedButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    showDialog(context: context,barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        }
    );
  }


  void _save() async {
    todo.title = titleController.text;
    todo.status = 'Pending';
    print("saving the data");

    int result = await databaseHelper.insertTodo(todo);
    if (result!=0)
      print('Saved');
    updateListView();
  }
  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result!=0) {
      _showSnackBar(context,'To-Do removed successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackbar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = databaseHelper.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }
}