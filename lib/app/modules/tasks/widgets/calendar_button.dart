import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/modules/tasks/task_create_controller.dart';

class CalendarButton extends StatelessWidget {
  CalendarButton({super.key});

  final dateFormat = DateFormat('dd/MM/y');

  DateTime? get selectedDate => null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var lastDate = DateTime.now();
        lastDate = lastDate.add(const Duration(days: 3650));
        final DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: lastDate);
        context.read<TaskCreateController>().selectedDate = selectedDate;
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.today,
              color: Colors.grey,
            ),
            const SizedBox(width: 5),
            Selector<TaskCreateController, DateTime?>(
              selector: (context, controller) => controller.selectedDate,
              builder: (context, selectedDate, child) {
                if (selectedDate != null) {
                  return Text(
                    dateFormat.format(selectedDate),
                    style: context.titleStyle,
                  );
                } else {
                  return Text(
                    'SELECIONE UMA DATA',
                    style: context.titleStyle,
                  );
                }
              },
              child: Text(
                'SELECIONE UMA DATA',
                style: context.titleStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
