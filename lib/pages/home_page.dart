import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_tutorial/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _textEditingController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
          onPressed: _displayTextInputDialog,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 20,
          )),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Center(
        child: Text("Todos List",
            style: TextStyle(
              color: Colors.white70,
            )),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          _messagesListView(),
        ],
      ),
    );
  }

  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).height,
      child: StreamBuilder(
          builder: (context, snapshot) {
            List todos = snapshot.data?.docs ?? [];
            if (todos.isEmpty) {
              return const Center(
                child: Text(
                  "No todos for the day!! Add one",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              );
            }

            return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  Todo todo = todos[index].data();
                  String todoId = todos[index].id;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.primaryContainer,
                      title: Text(todo.task),
                      subtitle: Text(
                        DateFormat("dd-MM-yyyy h:mm a").format(
                          todo.updatedOn.toDate(),
                        ),
                      ),
                      trailing: Checkbox(
                        value: todo.isDone,
                        onChanged: (value) {
                          Todo updatedTodo = todo.copyWith(
                            isDone: !todo.isDone,
                            updatedOn: Timestamp.now(),
                          );
                          _databaseService.updateTodo(todoId, updatedTodo);
                        },
                      ),
                      onLongPress: () {
                        _databaseService.deleteTodo(todoId);
                      },
                    ),
                  );
                });
          },
          stream: _databaseService.getTodos()),
    );
  }

  void _displayTextInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add a todo"),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: "Todo...",
            ),
          ),
          actions: <Widget>[
            MaterialButton(
                color: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                child: const Text("Ok"),
                onPressed: (){
                  Todo todo = Todo(
                      createdOn: Timestamp.now(),
                      task: _textEditingController.text,
                      isDone: false,
                      updatedOn: Timestamp.now()
                  );
                  Navigator.pop(context);
                  _textEditingController.clear();
                },
            ),
          ],
        );
      },
    );
  }
}
