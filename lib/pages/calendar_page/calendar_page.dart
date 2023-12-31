import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_flutter/controllers/task_controller.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';
import 'calendar_task_list.dart';

class CalendarPage extends StatelessWidget {
   CalendarPage({super.key});
   final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Calendar",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedTab: 2,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CalendarTimeline(
              initialDate: taskController.selectedDateOnCalendarPage.value,
              firstDate: DateTime(2022,01, 01),
              lastDate: DateTime(2090, 01, 01),
              onDateSelected: (date) => taskController.selectedDateOnCalendarPage.value = date,
              leftMargin: 20,
              monthColor: Colors.blueGrey,
              dayColor: Colors.teal[200],
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.redAccent[100],
              dotsColor: Color(0xFF333A47),
              //selectableDayPredicate: (date) => date.day != 23,
              //locale: 'ru_ISO',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15.0),
              child: CalendarTaskList(taskController:taskController),
            ),
          ],
        ),
      )
    );
  }
}
