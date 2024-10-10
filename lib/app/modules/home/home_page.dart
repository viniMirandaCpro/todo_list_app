// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:todo_list/app/core/notifier/default_listener_notifier.dart';

import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/core/ui/todo_list_icons.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/home/widgets/home_drawer.dart';
import 'package:todo_list/app/modules/home/widgets/home_filters.dart';
import 'package:todo_list/app/modules/home/widgets/home_header.dart';
import 'package:todo_list/app/modules/home/widgets/home_tasks.dart';
import 'package:todo_list/app/modules/home/widgets/home_week_filter.dart';
import 'package:todo_list/app/modules/tasks/tasks_module.dart';

class HomePage extends StatefulWidget {
  final HomeController _homeController;
  const HomePage({
    super.key,
    required HomeController homeController,
  }) : _homeController = homeController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: widget._homeController).listener(
        context: context,
        sucessCallback: (notifier, listenerInstance) {
          listenerInstance.dispose();
        });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget._homeController.loadTotalTasks();
      widget._homeController.findTasks(filter: TaskFilterEnum.today);
    });
  }

  Future<void> _goToCreateTask(BuildContext context) async {
    // Navigator.of(context).pushNamed('/task/create');
    await Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        animation =
            CurvedAnimation(parent: animation, curve: Curves.easeInQuad);
        return ScaleTransition(
          scale: animation,
          alignment: Alignment.bottomRight,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return TasksModule().getPage('/task/create', context);
      },
    ));
    widget._homeController.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () => _goToCreateTask(context),
            backgroundColor: context.primaryColorLight,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: const Icon(Icons.add)),
        appBar: AppBar(
          iconTheme: IconThemeData(color: context.primaryColor),
          backgroundColor: const Color(0xFFFAFBFE),
          elevation: 0,
          foregroundColor: const Color(0xFFFAFBFE),
          shadowColor: const Color(0xFFFAFBFE),
          actions: [
            PopupMenuButton(
              icon: const Icon(TodoList.filter),
              onSelected: (value) {
                widget._homeController.showOrHideFinishedTasks();
              },
              itemBuilder: (_) => [
                PopupMenuItem<bool>(
                  value: true,
                  child: Text(widget._homeController.showFinishedTaks
                      ? 'Esconder tarefas concluídas'
                      : 'Mostrar tarefas concluídas'),
                )
              ],
            )
          ],
        ),
        backgroundColor: const Color(0xFFFAFBFE),
        drawer: HomeDrawer(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: const IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeHeader(),
                        HomeFilters(),
                        HomeWeekFilter(),
                        HomeTasks(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
