import 'package:hive/hive.dart';

part 'task_status_enum.g.dart';

@HiveType(typeId: 1)
enum TaskStatus {
  @HiveField(0)
  onProgress,

  @HiveField(1)
  upcoming,

  @HiveField(2)
  dueSoon,

  @HiveField(3)
  completed,
}