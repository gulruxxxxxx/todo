import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Repository repository;

  @override
  void initState() {
    repository = Repository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) =>
                AddToDoDialog(repository: repository),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<ToDoModel>>(
        stream: repository.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No ToDo'));
          } else {
            final todos = snapshot.data!;
            return ListView.separated(
              itemBuilder: (_, index) => ToDoItemWidget(
                todo: todos[index],
                onDelete: () {
                  repository.deleteToDo(todos[index].id);
                },
              ),
              separatorBuilder: (_, __) => const SizedBox(
                height: 6,
              ),
              itemCount: todos.length,
            );
          }
        },
      ),
    );
  }
}

class AddToDoDialog extends StatefulWidget {
  final Repository repository;

  const AddToDoDialog({required this.repository});

  @override
  _AddToDoDialogState createState() => _AddToDoDialogState();
}

class _AddToDoDialogState extends State<AddToDoDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add ToDo'),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              await widget.repository.createToDo(
                _titleController.text,
                _descriptionController.text,
              );
              Navigator.of(context).pop();
            } catch (e) {}
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

class ToDoItemWidget extends StatelessWidget {
  final ToDoModel todo;
  final VoidCallback onDelete;

  const ToDoItemWidget({
    required this.todo,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        tileColor: Colors.indigo[200],
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          todo.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(todo.description),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
