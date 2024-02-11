import 'package:cloud_firestore/cloud_firestore.dart';

class Todo{
  String task;
  bool isDone;
  Timestamp createdOn;
  Timestamp updatedOn;

  Todo({
    required this.createdOn,
    required this.task,
    required this.isDone,
    required this.updatedOn});

  Todo.fromJson(Map<String, Object?> json) :
        this(
          task: json['task']! as String,
          isDone: json['isDone']! as bool,
          updatedOn: json['updatedOn']! as Timestamp,
          createdOn: json['createdOn']! as Timestamp,
      );

   Todo copyWith({
          String? task,
          bool? isDone,
          Timestamp? createdOn,
          Timestamp? updatedOn,
        }) {
     return Todo(
       task: task ?? this.task,
       isDone: isDone ?? this.isDone,
       updatedOn: updatedOn ?? this.updatedOn,
       createdOn: createdOn ?? this.createdOn,
     );
   }

   Map<String, Object?> toJson(){
     return{
      'task':task,
      'isDone':isDone,
      'createdOn':createdOn,
       'updatedOn':updatedOn,
     };
   }
}