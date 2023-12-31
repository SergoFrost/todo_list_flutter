import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../model/task_model.dart';
import '../model/task_status_enum.dart';

class AddNewTaskPopup extends StatefulWidget {
  const AddNewTaskPopup({super.key});

  @override
  _AddNewTaskPopupState createState() => _AddNewTaskPopupState();
}

class _AddNewTaskPopupState extends State<AddNewTaskPopup> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _descriptionController = TextEditingController();

  String? _titleError;
  String? _descriptionError;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add New Task',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  errorText: _titleError,
                ),
                maxLength: 60,
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Expanded(
                    child: Text('Due Date:'),
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _selectedDate) {
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
                      if (picked != null && picked != _selectedTime) {
                        setState(() {
                          _selectedTime = picked;
                        });
                      }
                    },
                    child: Text(_selectedTime.format(context)),
                  ),
                ],
              ),
              TextField(
                controller: _descriptionController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Description',
                  errorText: _descriptionError,
                ),
                maxLength: 150,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.transparent),
                    onPressed: () {
                      // Close the pop-up
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Validate the inputs
                      bool isValid = true;

                      if (_titleController.text.isEmpty) {
                        isValid = false;
                        setState(() {
                          _titleError = 'Please enter a task title.';
                        });
                      } else {
                        setState(() {
                          _titleError = null;
                        });
                      }

                      if (_descriptionController.text.isEmpty) {
                        isValid = false;
                        setState(() {
                          _descriptionError = 'Please enter a description.';
                        });
                      } else {
                        setState(() {
                          _descriptionError = null;
                        });
                      }

                      if (isValid) {
                        // Handle the task addition logic here
                        String title = _titleController.text;
                        String description = _descriptionController.text;

                        TaskModel newTask = TaskModel(
                          title: title,
                          dueDate: DateTime(
                              _selectedDate.year,
                              _selectedDate.month,
                              _selectedDate.day,
                              _selectedTime.hour,
                              _selectedTime.minute),
                          description: description,
                          status: TaskStatus.onProgress,
                        );

                        TaskController taskController =
                            Get.put(TaskController());
                        await taskController.addTask(newTask);

                        // Perform actions with the task details (e.g., store them, display them, etc.)

                        // Close the pop-up
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
