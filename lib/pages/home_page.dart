import 'package:firestore_tutorial/services/database_service.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),
    );
  }

  PreferredSizeWidget _appBar(){
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Center(
          child: Text(
            "Todos List",
            style:TextStyle(
              color:Colors.white70,
            )
          ),),
    );
  }

  Widget _buildUI(){
    return SafeArea(
        child: Column(
          children: [
            _messagesListView(),
          ],
        ),
    );
  }

  Widget _messagesListView(){
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).height,
      child: StreamBuilder(
        builder: (context,snapshot){
          List todos = snapshot.data?.docs ?? [];
          if(todos.isEmpty){
            return const Center(
              child: Text(
                  "No todos for the day!! Add one",
                style:TextStyle(
                  color:Colors.black45,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            );
          }
          print(todos);
          return ListView();
        },
        stream:_databaseService.getTodos()
      ),
    );
  }
}
