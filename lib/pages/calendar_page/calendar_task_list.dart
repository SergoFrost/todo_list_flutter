import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:todo_list_flutter/controllers/task_controller.dart';

import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../model/task_model.dart';
import '../task_detail_page/task_detail_page.dart';

class CalendarTaskList extends StatelessWidget {
  final TaskController taskController;

  const CalendarTaskList({super.key, required this.taskController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDate = taskController.selectedDateOnCalendarPage.value;
      final tasksForDate = taskController.getTasksForDate(selectedDate);
      print(selectedDate);
      print(tasksForDate.length);
      // Group tasks by time
      final groupedTasks = groupTasksByTime(tasksForDate);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Tasks of ${DateFormat('d MMMM').format(selectedDate)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          groupedTasks.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Text(
                      "No tasks for this date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: groupedTasks.length,
                  itemBuilder: (context, index) {
                    var taskGroup = groupedTasks[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 25.0, right: 10),
                              child: Text(
                                DateFormat('hh:mm a')
                                    .format(taskGroup.first.dueDate),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...taskGroup.map(
                                    (task) {
                                      final gradient = generateRandomGradient();
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: GestureDetector(
                                          onTap: ()=> Get.to(() => TaskDetailPage(
                                              task: task,
                                              taskController: taskController,
                                              backgroundColor: gradient)),
                                          child: Container(
                                            width:
                                                MediaQuery.of(context).size.width,
                                            padding: const EdgeInsets.all(15.0),
                                            margin: const EdgeInsets.only(
                                                bottom: 10.0, top: 5),
                                            decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 5,
                                                  offset: Offset(1, 1),
                                                ),
                                              ],
                                              gradient: gradient,
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  task.title,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  task.description,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(),
                                                ),
                                                /*Text(
                                                                                DateFormat('hh:mm a').format(task.dueDate),
                                                                              )*/
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1.5,
                          color: Color(0xffDCDFEA),
                        ),
                      ],
                    );
                  },
                ),
        ],
      );
    });
  }

  // Use RxList for reactive behavior
  RxList<List<TaskModel>> groupTasksByTime(List<TaskModel> tasks) {
    final groupedTasks = <List<TaskModel>>[];
    print(groupedTasks);
    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    for (var i = 0; i < tasks.length; i++) {
      final currentTask = tasks[i];

      if (groupedTasks.isEmpty ||
          !isSameTime(currentTask, groupedTasks.last.first)) {
        groupedTasks.add([currentTask]);
      } else {
        groupedTasks.last.add(currentTask);
      }
    }

    // Convert to RxList to make it reactive
    return groupedTasks.obs;
  }

  bool isSameTime(TaskModel task1, TaskModel task2) {
    return task1.dueDate.hour == task2.dueDate.hour &&
        task1.dueDate.minute == task2.dueDate.minute;
  }
}
