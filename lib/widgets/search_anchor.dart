import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controllers/task_controller.dart';
import '../model/task_model.dart';
import '../pages/task_detail_page/task_detail_page.dart';

class AsyncSearchAnchor extends StatefulWidget {
  final TaskController taskController;

  const AsyncSearchAnchor({super.key, required this.taskController});

  @override
  State<AsyncSearchAnchor> createState() => _AsyncSearchAnchorState();
}

class _AsyncSearchAnchorState extends State<AsyncSearchAnchor> {
  String? _searchingWithQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];

  Future<Iterable<String>> _search(String query) async {
    final List<TaskModel>? tasks = widget.taskController.searchTasks(query);

    // Обновляем результаты поиска в контроллере
    widget.taskController.updateSearchResults(tasks ?? []);

    return widget.taskController.searchResults.map((task) => task.title);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: SearchAnchor(
        viewHintText: "Search task...",
        viewConstraints: const BoxConstraints(minHeight: 200.0, maxHeight: 300.0),
        isFullScreen: false,
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            hintText: "Search task...",
            controller: controller,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 15.0)),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
          );
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) async {
          _searchingWithQuery = controller.text;

          if (_searchingWithQuery == null || _searchingWithQuery!.isEmpty) {
            // Возвращаем весь список задач, если поисковый запрос пуст
            return widget.taskController.tasks.map((task) {
              return ListTile(
                title: Text(task.title),
                onTap: () {
                  Get.to(() => TaskDetailPage(
                        task: task,
                        taskController: widget.taskController,
                      ));
                },
              );
            }).toList();
          } else {
            // Выполняем поиск
            final Iterable<String> options =
                await _search(_searchingWithQuery!);

            if (_searchingWithQuery != controller.text) {
              return _lastOptions;
            }

            _lastOptions = List<ListTile>.generate(
              options.length,
              (int index) {
                final String item = options.elementAt(index);
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    final TaskModel? selectedTask =
                        widget.taskController.getTaskByTitle(item);
                    if (selectedTask != null) {
                      Get.to(
                        () => TaskDetailPage(
                          task: selectedTask,
                          taskController: widget.taskController,
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
          return _lastOptions;
        },
      ),
    );
  }
}
