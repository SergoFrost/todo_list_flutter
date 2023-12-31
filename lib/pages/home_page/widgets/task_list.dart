import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_flutter/model/task_status_enum.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';
import '../../../controllers/task_controller.dart';
import '../../../model/task_model.dart';
import '../../task_detail_page/task_detail_page.dart';

class TaskList extends StatefulWidget {
  final TaskStatus taskStatus;
  final TaskController taskController;

  const TaskList(
      {Key? key, required this.taskStatus, required this.taskController})
      : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList>
    with SingleTickerProviderStateMixin {
  late AnimationController _deleteController;
  late Animation<double> _deleteAnimation;
  int? _indexOfDeletingTask;

  @override
  void initState() {
    super.initState();
    _deleteController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _deleteAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _deleteController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _deleteController.dispose();
    super.dispose();
  }

  Future<void> _deleteTaskWithAnimation(int index, TaskModel taskModel) async {
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      _indexOfDeletingTask = index;
    });
    await _deleteController.forward();
    widget.taskController.deleteTask(taskModel);
    setState(() {
      _indexOfDeletingTask = null;
    });
    _deleteController.reset();
  }

  Color getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    late MenuController menuController;

    return Obx(() {
      List<TaskModel> tasks = [];
      switch (widget.taskStatus) {
        case TaskStatus.onProgress:
          tasks = widget.taskController.todayTasks;
          break;
        case TaskStatus.upcoming:
          tasks = widget.taskController.upcomingTasks;
          break;
        case TaskStatus.dueSoon:
          tasks = widget.taskController.dueSoonTasks;
          break;
        case TaskStatus.completed:
          tasks = widget.taskController.completedTasks;
          break;
      }

      return tasks.isEmpty
          ? const Center(
              child: Text(
                "No tasks.\nPress + to add new task.",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                String formattedDate =
                    DateFormat("dd MMM yyyy hh:mm").format(task.dueDate);
                var taskStatus = (() {
                  switch (task.status) {
                    case TaskStatus.onProgress:
                      return "On Progress";
                    case TaskStatus.upcoming:
                      return "Upcoming";
                    case TaskStatus.dueSoon:
                      return "Due soon";
                    case TaskStatus.completed:
                      return "Completed";
                    default:
                      return "Unknown";
                  }
                })();

                final gradient = generateRandomGradient();
                final textColor = getContrastingTextColor(gradient.colors[0]);

                return AnimatedBuilder(
                  animation: _deleteAnimation,
                  builder: (context, child) {
                    return _indexOfDeletingTask == index
                        ? Transform.scale(
                            scale: _deleteAnimation.value,
                            child: child,
                          )
                        : child!;
                  },
                  child: GestureDetector(
                    onTap: () => Get.to(() => TaskDetailPage(
                        task: task,
                        taskController: widget.taskController,
                        backgroundColor: gradient)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15.0),
                      child: AnimatedSize(
                        key: ValueKey<int>(tasks.length),
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          margin: const EdgeInsets.only(bottom: 15.0),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                offset: Offset(1, 1),
                              ),
                            ],
                            gradient: gradient,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      task.title,
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  MenuAnchor(
                                    alignmentOffset: const Offset(-110, 0),
                                    style: const MenuStyle(
                                      alignment: Alignment.bottomLeft,
                                      elevation: MaterialStatePropertyAll(12),
                                      shadowColor: MaterialStatePropertyAll(
                                        Color.fromARGB(50, 217, 217, 217),
                                      ),
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.all(10.0)),
                                    ),
                                    builder: (BuildContext context,
                                        MenuController controller,
                                        Widget? child) {
                                      menuController = controller;
                                      return GestureDetector(
                                        onTap: () {
                                          if (controller.isOpen) {
                                            controller.close();
                                          } else {
                                            controller.open();
                                          }
                                        },
                                        child: const Icon(
                                          Icons.more_horiz_outlined,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                    menuChildren: [
                                      GestureDetector(
                                        onTap: () {
                                          menuController.close();
                                          Get.to(() => TaskDetailPage(
                                                task: task,
                                                isEditing: true,
                                                taskController:
                                                    widget.taskController,
                                                backgroundColor: gradient,
                                              ));
                                        },
                                        child: const Text(
                                          'Edit',
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 13,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          menuController.close();
                                          await Future.delayed(const Duration(
                                              milliseconds: 100));
                                          if (task.status ==
                                              TaskStatus.completed) {
                                            await widget.taskController
                                                .unCompleteTask(task);
                                          } else {
                                            await widget.taskController
                                                .completeTask(task);
                                          }
                                        },
                                        child: Text(
                                          task.status == TaskStatus.completed
                                              ? 'Task not completed'
                                              : 'Complete task',
                                          style:
                                              const TextStyle(fontSize: 15.0),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 13,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          menuController.close();
                                          Get.dialog(
                                            AlertDialog(
                                              title: const Text("Delete Task"),
                                              content: Text(
                                                  "Are you sure you want to delete task: ${task.title}?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Get.back(); // Закрыть диалог
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Закрыть диалог
                                                    _deleteTaskWithAnimation(
                                                        index, task);
                                                  },
                                                  child: const Text("Delete",
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: const Text('Delete',
                                            style: TextStyle(fontSize: 15.0)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                task.description,
                                style: TextStyle(color: textColor),
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  Icon(Icons.access_time,
                                      size: 18,
                                      color: ColorConstants.secondTextColor),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(fontSize: 13.0),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: ColorConstants
                                          .onProgressStatusColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Text(
                                      taskStatus.toString(),
                                      style: TextStyle(
                                        color: ColorConstants
                                            .onProgressTextStatusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
    });
  }
}
