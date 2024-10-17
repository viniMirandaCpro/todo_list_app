import 'package:flutter/material.dart';
import 'package:todo_list/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/core/widget/txt_form_field.dart';

import 'package:todo_list/app/modules/tasks/task_create_controller.dart';
import 'package:todo_list/app/modules/tasks/widgets/calendar_button.dart';
import 'package:validatorless/validatorless.dart';

class TaskCreatePage extends StatefulWidget {
  final TaskCreateController _controller;

  const TaskCreatePage({
    super.key,
    required TaskCreateController controller,
  }) : _controller = controller;

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final _descriptionEC = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(
      changeNotifier: widget._controller,
    ).listener(
        context: context,
        sucessCallback: (notifier, listenerInstance) {
          listenerInstance.dispose();
          Navigator.pop(context);
        });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          hoverColor: context.primaryColor,
          onPressed: () {
            final formValid = _formkey.currentState?.validate() ?? false;
            if (formValid) {
              widget._controller.save(_descriptionEC.text);
            }
          },
          label: const Text(
            'Salvar Task',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          )),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ],
        title: const Text('Tasks'),
      ),
      body: Form(
        key: _formkey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Criar Atividade',
                  style: context.titleStyle.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(height: 30),
              TxtFormField(
                label: '',
                controller: _descriptionEC,
                validator: Validatorless.required('Descrição é obrigatória'),
              ),
              const SizedBox(height: 20),
              CalendarButton()
            ],
          ),
        ),
      ),
    );
  }
}
