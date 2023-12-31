// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_status_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final int typeId = 1;

  @override
  TaskStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskStatus.onProgress;
      case 1:
        return TaskStatus.upcoming;
      case 2:
        return TaskStatus.dueSoon;
      case 3:
        return TaskStatus.completed;
      default:
        return TaskStatus.onProgress;
    }
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    switch (obj) {
      case TaskStatus.onProgress:
        writer.writeByte(0);
        break;
      case TaskStatus.upcoming:
        writer.writeByte(1);
        break;
      case TaskStatus.dueSoon:
        writer.writeByte(2);
        break;
      case TaskStatus.completed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
