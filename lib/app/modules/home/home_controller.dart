import 'package:todo_list/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/models/total_tasks_model.dart';
import 'package:todo_list/app/models/week_task_model.dart';
import 'package:todo_list/app/services/tasks/tasks_service.dart';

class HomeController extends DefaultChangeNotifier {
  final TasksService _tasksService;
  var filterSelected = TaskFilterEnum.today;
  TotalTasksModel? todayTotalTasks;
  TotalTasksModel? tomorrowTotalTasks;
  TotalTasksModel? weekTotalTasks;
  List<TaskModel> allTasks = [];
  List<TaskModel> filteredTasks = [];
  DateTime? initialDateOfWeek;
  DateTime? selectedDay;
  bool showFinishedTaks = false;

  HomeController({required TasksService tasksService})
      : _tasksService = tasksService;

  Future<void> loadTotalTasks() async {
    final alltasks = await Future.wait([
      _tasksService.getToday(),
      _tasksService.getTomorrow(),
      _tasksService.getWeek(),
    ]);

    final todayTasks = alltasks[0] as List<TaskModel>;
    final tomorrowTasks = alltasks[1] as List<TaskModel>;
    final weekTasks = alltasks[2] as WeekTaskModel;

    todayTotalTasks = TotalTasksModel(
        totalTasks: todayTasks.length,
        totalTasksFinished: todayTasks.where((task) => task.finished).length);

    tomorrowTotalTasks = TotalTasksModel(
        totalTasks: tomorrowTasks.length,
        totalTasksFinished:
            tomorrowTasks.where((task) => task.finished).length);

    weekTotalTasks = TotalTasksModel(
        totalTasks: weekTasks.tasks.length,
        totalTasksFinished:
            weekTasks.tasks.where((task) => task.finished).length);

    notifyListeners();
  }

  Future<void> findTasks({required TaskFilterEnum filter}) async {
    filterSelected = filter;
    showLoading();
    notifyListeners();
    List<TaskModel> tasks;

    switch (filter) {
      case TaskFilterEnum.today:
        tasks = await _tasksService.getToday();
        break;
      case TaskFilterEnum.tomorrow:
        tasks = await _tasksService.getTomorrow();
        break;
      case TaskFilterEnum.week:
        final weekModel = await _tasksService.getWeek();
        initialDateOfWeek = weekModel.startDate;
        tasks = weekModel.tasks;
        break;
    }
    filteredTasks = tasks;
    allTasks = tasks;

    if (filter == TaskFilterEnum.week) {
      if (selectedDay != null) {
        filterByDay(selectedDay!);
      } else if (initialDateOfWeek != null) {
        filterByDay(initialDateOfWeek!);
      } else {
        selectedDay = null;
      }
    }

    if (!showFinishedTaks) {
      filteredTasks = filteredTasks.where((task) => !task.finished).toList();
    }

    hideLoading();
    notifyListeners();
  }

  void filterByDay(DateTime date) {
    selectedDay = date;
    filteredTasks = allTasks.where((task) {
      return task.dateTime == date;
    }).toList();
    notifyListeners();
  }

  Future<void> refreshPage() async {
    await findTasks(filter: filterSelected);
    await loadTotalTasks();
    notifyListeners();
  }

  Future<void> checkOrUncheckTask(TaskModel task) async {
    showLoadingAndResetState();
    notifyListeners();
    final taskUpdate = task.copyWith(finished: !task.finished);
    await _tasksService.checkOrUncheck(taskUpdate);
    hideLoading();
    refreshPage();
  }

  void showOrHideFinishedTasks() {
    showFinishedTaks = !showFinishedTaks;
    refreshPage();
  }

  void deleteTask(int taskId) async {
    try {
      await _tasksService.deleteTask(taskId);
      allTasks.removeWhere((task) => task.id == taskId);
      filteredTasks.removeWhere((task) => task.id == taskId);

      notifyListeners();

      print('Task deleted');
      refreshPage();
    } catch (e) {
      print('Erro ao deletar a task: $e');
    }
  }
}
