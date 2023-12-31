import 'dart:async';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model/sub_task_model.dart';
import '../model/task_model.dart';
import '../model/task_status_enum.dart';

class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs;
  final RxList<TaskModel> searchResults = <TaskModel>[].obs;
  // Add an observable list of subtasks
  RxList<SubTask> subTasks = <SubTask>[].obs;
  var selectedDateOnCalendarPage = DateTime.now().obs;

  @override
  void onInit() async {
    super.onInit();
    loadTasks();
  }

  // Добавляет новую задачу
  Future<void> addTask(TaskModel task) async {
    var box = await Hive.openBox<TaskModel>('tasks');
    await box.add(task);
    await loadTasks();
  }

  // Загружает задачи из хранилища
  Future<void> loadTasks() async {
    var box = await Hive.openBox<TaskModel>('tasks');
    tasks.value = box.values.toList();
  }

// Обновляет существующую задачу
  Future<void> updateTask(TaskModel updatedTask) async {
    var box = await Hive.openBox<TaskModel>('tasks');
    int index = tasks.indexWhere((task) => task.key == updatedTask.key);
    print(index);
    print(updatedTask.title);
    if (index != -1) {
      await box.put(updatedTask.key, updatedTask);
      await box.compact(); // Опционально компактизируем бокс (можно добавить)
      await loadTasks();
    }
  }
  // Удаляет задачу
  Future<void> deleteTask(TaskModel taskToDelete) async {
    var box = await Hive.openBox<TaskModel>('tasks');
    await box.delete(taskToDelete.key);
    await loadTasks();
  }

  // Помечает задачу как завершенную
  Future<void> completeTask(TaskModel task) async {
    task.status = TaskStatus.completed;
    await updateTask(task);
  }

  // Возобновляет выполнение задачи
  Future<void> unCompleteTask(TaskModel task) async {
    task.status = TaskStatus.onProgress;
    await updateTask(task);
  }

  // Возвращает список названий задач
  List<String> getTaskTitles() => tasks.map((task) => task.title).toList();

  // Возвращает задачу по ее названию
  TaskModel? getTaskByTitle(String title) => tasks.firstWhereOrNull((task) => task.title == title);

  // Поиск задач по запросу
  List<TaskModel>? searchTasks(String query) {
    if (query == '') {
      return List<TaskModel>.empty();
    }

    final results = tasks.where((task) => task.title.toLowerCase().contains(query.toLowerCase())).toList();
    searchResults.assignAll(results);
    return results;
  }

  // Обновление результатов поиска
  void updateSearchResults(List<TaskModel> results) {
    searchResults.assignAll(results);
  }

  // Функция для сортировки задач по времени
  void _sortTasksByDueDate(List<TaskModel> taskList) {
    taskList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // Возвращает задачи на сегодня
  List<TaskModel> get todayTasks {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final List<TaskModel> todayTasks = tasks.where((task) {
      final dueDate = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      return task.status != TaskStatus.completed && (dueDate.isBefore(today) || dueDate.isAtSameMomentAs(today));
    }).toList();

    _sortTasksByDueDate(todayTasks);
    return todayTasks;
  }

  // Возвращает задачи на следующий день
  List<TaskModel> get upcomingTasks => tasks.where((task) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    return (task.dueDate.isAfter(DateTime.now()) || task.dueDate.isAtSameMomentAs(DateTime.now())) &&
        task.dueDate.isBefore(DateTime(tomorrow.year, tomorrow.month, tomorrow.day + 1)) &&
        task.status != TaskStatus.completed;
  }).toList();

  // Возвращает задачи, которые должны быть выполнены в течение ближайших двух дней
  List<TaskModel> get dueSoonTasks => tasks.where((task) {
    return (task.dueDate.difference(DateTime.now()).inDays >= 2) &&
        task.status != TaskStatus.completed;
  }).toList();

  // Возвращает завершенные задачи
  List<TaskModel> get completedTasks => tasks.where((task) => task.status == TaskStatus.completed).toList();

// Function to get the list of subtasks for a specific task
  RxList<SubTask> getSubTasks(TaskModel task) {
    subTasks.assignAll(task.subTasks);
    return subTasks;
  }

// Function to add a new subtask to the current task
  Future<void> addSubTask(TaskModel task, SubTask subTask) async {
    task.subTasks.add(subTask);
    subTasks.assignAll(task.subTasks); // Update the observable list
    await updateTask(task);
  }

  // Function to update the status of a subtask in the current task
  Future<void> updateSubTaskStatus(TaskModel task, SubTask subTask, bool isChecked) async {
    subTask.isCompleted = isChecked;
    await updateTask(task);
    getSubTasks(task);
  }

  // Function to delete a subtask from the current task
  Future<void> deleteSubTask(TaskModel task, SubTask subTask) async {
    task.subTasks.remove(subTask);
    subTasks.assignAll(task.subTasks); // Update the observable list
    await updateTask(task);
  }

  List<TaskModel> getTasksForDate(DateTime selectedDate) {
    final result = tasks.where((task) {
      final taskDate = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      final selectedDateWithoutTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      return taskDate.isAtSameMomentAs(selectedDateWithoutTime);
    }).toList();
    return result;
  }

}
