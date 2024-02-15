import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Repository {
  final List<ToDoModel> _todos = [];
  final StreamController<List<ToDoModel>> _controller =
  StreamController<List<ToDoModel>>();

  Stream<List<ToDoModel>> get stream async* {
    yield* _controller.stream;
  }

  Future<void> createToDo(String title, String description) async {
    final newToDo = ToDoModel(
      id: _todos.isEmpty ? 0 : _todos.last.id + 1,
      title: title,
      description: description,
    );
    _todos.add(newToDo);
    print('Todo $_todos');
    _controller.add(_todos);
  }

  void deleteToDo(int id) {
    _todos.removeWhere((todo) => todo.id == id);
    _controller.add(_todos);
  }
}

class ToDoModel {
  final int id;
  final String title;
  final String description;

  ToDoModel({required this.id, required this.title, required this.description});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ToDoModel &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              title == other.title &&
              description == other.description;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ description.hashCode;

  @override
  String toString() {
    return 'ToDoModel{id: $id, title: $title, description: $description}';
  }
}