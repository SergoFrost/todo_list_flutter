import 'package:hive/hive.dart';

part 'sub_task_model.g.dart';

@HiveType(typeId: 2)
class SubTask {
  @HiveField(0)
  String subTaskTitle;

  @HiveField(1)
  bool isCompleted;

  SubTask({required this.subTaskTitle, required this.isCompleted});
}