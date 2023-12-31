import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list_flutter/model/sub_task_model.dart';
import 'package:todo_list_flutter/pages/calendar_page/calendar_page.dart';
import 'package:todo_list_flutter/pages/home_page/home_page.dart';
import 'package:todo_list_flutter/pages/settings_page/settings_page.dart';
import 'package:todo_list_flutter/pages/stats_page/stats_page.dart';

import 'model/task_model.dart';
import 'model/task_status_enum.dart';


/// Project: flutter todo list
/// Author: Serhii Moroz
/// Company: Frostrabbit
/// Created on: December 20, 2023


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  // Register the adapters
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(SubTaskAdapter());

  // Открываем Hive бокс для нашей модели задачи
  await Hive.openBox<TaskModel>('tasks');

  runApp(const MyApp());

  // Закрываем Hive бокс при завершении работы приложения
  await Hive.close();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/stats', page: () => StatsPage()),
        GetPage(name: '/calendar', page: () => CalendarPage()),
        GetPage(
            name: '/settings',
            page: () => SettingsPage(),
            transition: Transition.zoom),
      ],
    );
  }
}
