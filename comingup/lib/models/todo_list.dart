import 'dart:convert';

import 'package:comingup/models/todo.dart';

class TodoList {
  final List<Todo>? todos;
  TodoList({this.todos});

  factory TodoList.fromJson(String jsonString) {
    List<dynamic> listFromJson = json.decode(jsonString);
    List<Todo> todos = <Todo>[];

    todos = listFromJson.map((todo) => Todo.fromJson(todo)).toList();
    return TodoList(todos: todos);
  }
}
