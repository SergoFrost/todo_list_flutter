import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todo_list_flutter/constants.dart';
import 'package:todo_list_flutter/model/task_model.dart';
import 'package:intl/intl.dart';
import '../../controllers/task_controller.dart';
import '../../model/sub_task_model.dart';
import '../../model/task_status_enum.dart';
import '../home_page/widgets/sub_tasks.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskModel task;
  final bool isEditing;
  final TaskController taskController;
  final LinearGradient backgroundColor; // New property

  const TaskDetailPage({
    Key? key,
    required this.task,
    this.isEditing = false,
    required this.taskController,
    this.backgroundColor = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.white, Colors.white],
    ), // Initialize the new property
  }) : super(key: key);

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dueDateController;
  late TextEditingController subTasksController;

  RxBool isEditing = false.obs;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  String formattedDate(DateTime dateTime) {
    String formattedDate =
        DateFormat("dd MMM yyyy hh:mm").format(widget.task.dueDate);
    return formattedDate;
  }

  Future<void> showAddSubTaskDialog(TaskModel task) async {
    TextEditingController subTaskController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text("Add New Subtask"),
        content: TextField(
          controller: subTaskController,
          decoration: const InputDecoration(
            hintText: 'Enter subtask title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (subTaskController.text.isNotEmpty) {
                // Add the new subtask to the current task using the controller
                SubTask newSubTask = SubTask(
                    subTaskTitle: subTaskController.text, isCompleted: false);
                await widget.taskController.addSubTask(task, newSubTask);
                Get.back(); // Close the dialog
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Future<void> showEditSubTaskDialog(SubTask subTask) async {
    TextEditingController editSubTaskController =
        TextEditingController(text: subTask.subTaskTitle);
    Get.dialog(
      AlertDialog(
        title: const Text("Edit subtask"),
        content: TextField(
          controller: editSubTaskController,
          decoration: const InputDecoration(
            hintText: 'Edit subtask title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (editSubTaskController.text.isNotEmpty) {
                // Update the subtask title
                subTask.subTaskTitle = editSubTaskController.text;

                // Update the subtask status
                await widget.taskController.updateSubTaskStatus(
                    widget.task, subTask, subTask.isCompleted);

                Get.back(); // Close the dialog
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isEditing.value = widget.isEditing;
    _selectedDate = widget.task.dueDate;
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    dueDateController =
        TextEditingController(text: widget.task.dueDate.toString());
    subTasksController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: widget.backgroundColor),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text("Task Details"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Task title",
                      style: TextStyle(
                        color: ColorConstants.secondTextColor,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        isEditing.toggle(); // Toggle isEditing using RxBool
                      },
                      child: Obx(() {
                        return isEditing.value
                            ? Row(
                                children: [
                                  const Icon(
                                    Icons.close,
                                    size: 26,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      // Логика сохранения изменений
                                      widget.task.title = titleController.text;
                                      widget.task.dueDate = DateTime(
                                        _selectedDate.year,
                                        _selectedDate.month,
                                        _selectedDate.day,
                                        _selectedTime.hour,
                                        _selectedTime.minute,
                                      );
                                      widget.task.description =
                                          descriptionController.text;
                                      widget.task.status =
                                          TaskStatus.onProgress;

                                      await widget.taskController
                                          .updateTask(widget.task);

                                      isEditing.toggle(); // Toggle isEditing
                                    },
                                    child: const Icon(
                                      Icons.check,
                                      size: 26,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              )
                            : SvgPicture.asset(
                                "assets/other_icons/edit_icon.svg",
                                height: 26,
                              );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Obx(() {
                  return isEditing.value
                      ? TextField(
                          controller: titleController,
                          maxLength: 60,
                          decoration: const InputDecoration(
                            hintText: 'Enter value',
                          ),
                        )
                      : Text(
                          widget.task.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                }),
                const SizedBox(height: 20),
                // Due date
                Text(
                  "Due date",
                  style: TextStyle(
                    color: ColorConstants.secondTextColor,
                    fontSize: 16,
                  ),
                ),
                Obx(() {
                  return isEditing.value
                      ? Column(
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text('Due Date:'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: widget.task.dueDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (picked != null &&
                                        picked != _selectedDate) {
                                      setState(() {
                                        _selectedDate = picked;
                                      });
                                    }
                                  },
                                  child: Text(
                                    '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text('Due Time:'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    TimeOfDay? picked = await showTimePicker(
                                      context: context,
                                      initialTime: _selectedTime,
                                    );
                                    if (picked != null &&
                                        picked != _selectedTime) {
                                      setState(() {
                                        _selectedTime = picked;
                                      });
                                    }
                                  },
                                  child: Text(_selectedTime.format(context)),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 5),
                            Text(
                              formattedDate(DateTime(
                                  _selectedDate.year,
                                  _selectedDate.month,
                                  _selectedDate.day,
                                  _selectedTime.hour,
                                  _selectedTime.minute)),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(
                                widget.task.status.name.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                }),
                const SizedBox(height: 20),

                // Descriptions
                Text(
                  "Descriptions",
                  style: TextStyle(
                    color: ColorConstants.secondTextColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Obx(() {
                  return isEditing.value
                      ? TextField(
                          maxLines: null,
                          maxLength: 150,
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Enter value',
                          ),
                        )
                      : Text(
                          widget.task.description,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        );
                }),
                const SizedBox(height: 20),

                // Stages of Task
                Text(
                  "Stages of Task",
                  style: TextStyle(
                    color: ColorConstants.secondTextColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Obx(
                  () {
                    final subTasks =
                        widget.taskController.getSubTasks(widget.task);
                    if (subTasks.isEmpty) {
                      return const Text(
                          'Subtasks is empty. Press + to add new subtask');
                    } else {
                      MenuController menuController = MenuController();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var newSubTask in subTasks)
                            Row(
                              children: [
                                SubTasks(
                                  subTaskTitle: newSubTask.subTaskTitle,
                                  isCompleted: newSubTask.isCompleted,
                                  onCheckboxChanged: (isChecked) async {
                                    // Update the subtask status
                                    await widget.taskController
                                        .updateSubTaskStatus(
                                            widget.task, newSubTask, isChecked);
                                  },
                                  trailing: MenuAnchor(
                                    alignmentOffset: const Offset(-50, 0),
                                    style: const MenuStyle(
                                      alignment: Alignment.bottomLeft,
                                      elevation: MaterialStatePropertyAll(12),
                                      shadowColor: MaterialStatePropertyAll(
                                        Color.fromARGB(50, 217, 217, 217),
                                      ),
                                      padding: MaterialStatePropertyAll(
                                        EdgeInsets.all(10.0),
                                      ),
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
                                          showEditSubTaskDialog(newSubTask);
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
                                        onTap: () {
                                          menuController.close();
                                          Get.dialog(
                                            AlertDialog(
                                              title: const Text("Delete Task"),
                                              content: Text(
                                                  "Are you sure you want to delete task: ${newSubTask.subTaskTitle}?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Get.back(); // Закрыть диалог
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Пример вызова функции удаления
                                                    widget.taskController
                                                        .deleteSubTask(
                                                            widget.task,
                                                            newSubTask);
                                                    Navigator.of(context)
                                                        .pop(); // Закрыть диалог
                                                  },
                                                  child: const Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Add MenuAnchor for editing a subtask
                              ],
                            ),
                        ],
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Show the dialog and add a new subtask
            await showAddSubTaskDialog(widget.task);
          },
          tooltip: 'Add new task subtask',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
