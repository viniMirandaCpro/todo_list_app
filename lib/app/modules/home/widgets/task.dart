// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';

class Task extends StatelessWidget {
  final TaskModel model;
  final dateFormate = DateFormat('dd/MM/y');
  Task({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        elevation: .2,
        shape: RoundedRectangleBorder(
            side: const BorderSide(width: .3, color: Colors.grey),
            borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        child: ListTile(
          contentPadding: const EdgeInsets.all(5),
          leading: Checkbox(
              value: model.finished,
              onChanged: (value) =>
                  context.read<HomeController>().checkOrUncheckTask(model)),
          title: Text(
            model.description,
            style: TextStyle(
                decoration: model.finished ? TextDecoration.lineThrough : null),
          ),
          subtitle: Text(
            dateFormate.format(model.dateTime),
            style: TextStyle(
                decoration: model.finished ? TextDecoration.lineThrough : null),
          ),
        ),
      ),
    );
  }
}
