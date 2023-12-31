import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:todo_list_flutter/model/task_status_enum.dart';
import 'package:todo_list_flutter/pages/home_page/widgets/task_list.dart';
import 'package:todo_list_flutter/widgets/add_new_task_popup.dart';
import 'package:todo_list_flutter/widgets/custom_bottom_navigation_bar.dart';

import '../../controllers/task_controller.dart';
import '../../model/task_model.dart';
import '../../widgets/search_anchor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final TaskController taskController = Get.put(TaskController());
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedTab: 0,
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: null,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 22,
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jhon Doe",
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  "39 tasks today",
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    offset: Offset(2, 2), // Shadow position
                  ),
                ],
              ),
              child: SvgPicture.asset("assets/other_icons/edit_icon.svg"),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25.0,
          ),
          AsyncSearchAnchor(
            taskController: taskController,
          ),
          const SizedBox(
            height: 15.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Text(
              "My Task",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TabBar(
            isScrollable: true,
            controller: _tabController,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            tabs: const [
              Tab(text: "Today"),
              Tab(text: "Upcoming"),
              Tab(text: "Due Soon"),
              Tab(text: "Completed"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TaskList(
                    taskStatus: TaskStatus.onProgress,
                    taskController: taskController),
                TaskList(
                    taskStatus: TaskStatus.upcoming,
                    taskController: taskController),
                TaskList(
                    taskStatus: TaskStatus.dueSoon,
                    taskController: taskController),
                TaskList(
                    taskStatus: TaskStatus.completed,
                    taskController: taskController),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            const AddNewTaskPopup(),
            //barrierDismissible: false
          );
        },
        tooltip: 'Add new task',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
