import 'package:flutter/material.dart';

class SubTasks extends StatefulWidget {
  final String subTaskTitle;
  final bool isCompleted;
  final ValueChanged<bool>? onCheckboxChanged;
  final Widget trailing;

  const SubTasks({
    Key? key,
    required this.subTaskTitle,
    this.isCompleted = false,
    this.onCheckboxChanged,
    required this.trailing,
  }) : super(key: key);

  @override
  _SubTasksState createState() => _SubTasksState();
}

class _SubTasksState extends State<SubTasks> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
        decoration: BoxDecoration(
          color: const Color(0xffF9F9FB).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.0),

        ),
        child: Row(
          children: [
            Transform.scale(
              scale: 1.4,
              child: Checkbox(
                shape: const CircleBorder(),
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value ?? false;
                    widget.onCheckboxChanged?.call(_isChecked);
                  });
                },
              ),
            ),
            Expanded(child: Text(widget.subTaskTitle,style: const TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500),)),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
              child: widget.trailing,
            )
          ],
        ),
      ),
    );
  }
}