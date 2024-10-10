import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo_list/app/core/modules/todo_list_page.dart';

abstract class TodoListModule {
  final Map<String, WidgetBuilder> _routes;
  final List<SingleChildWidget>? _bindings;

  TodoListModule(
      {required Map<String, WidgetBuilder> routes,
      List<SingleChildWidget>? bindings})
      : _routes = routes,
        _bindings = bindings;

  Map<String, WidgetBuilder> get routes {
    return _routes.map(
      (key, pageBuilder) => MapEntry(
        key,
        (_) => TodoListPage(
          bindings: _bindings,
          page: pageBuilder,
        ),
      ),
    );
  }

  Widget getPage(String path, BuildContext context) {
    final widgetBuilder = _routes[path];
    if (widgetBuilder != null) {
      return TodoListPage(
        page: widgetBuilder,
        bindings: _bindings,
      );
    } else {
      throw Exception();
    }
  }
}
