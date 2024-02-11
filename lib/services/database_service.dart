
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/todo.dart';

const String TODO_COLLECTION_REF = "todos";

class DatabaseService{

  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _todosRef;

  DatabaseService(){
   _todosRef = _firestore.collection(TODO_COLLECTION_REF).
                withConverter<Todo>(
                  fromFirestore: fromFirestore,
                  toFirestore: toFirestore);
  }
}