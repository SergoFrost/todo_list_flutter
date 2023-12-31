import 'package:hive/hive.dart';
import 'package:todo_list_flutter/model/sub_task_model.dart';
import 'package:todo_list_flutter/model/task_status_enum.dart';

part 'task_model.g.dart';



@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime dueDate;

  @HiveField(2)
  String description;

  @HiveField(3)
  TaskStatus status;

  @HiveField(4)
  List<SubTask> subTasks;

  TaskModel({required this.title, required this.dueDate, required this.description,required this.status, List<SubTask>? subTasks})
      : subTasks = subTasks ?? [];
}