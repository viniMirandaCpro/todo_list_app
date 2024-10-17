import 'package:todo_list/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list/app/services/tasks/tasks_service.dart';

class TaskCreateController extends DefaultChangeNotifier {
  final TasksService _tasksService;
  DateTime? _selectedDate;

  TaskCreateController({required TasksService tasksService})
      : _tasksService = tasksService;

  set selectedDate(DateTime? selectedDate) {
    resetState();
    _selectedDate = selectedDate;
    notifyListeners();
  }

  DateTime? get selectedDate => _selectedDate;

  Future<void> save(String description) async {
    try {
      showLoadingAndResetState();

      notifyListeners();
      if (_selectedDate != null) {
        await _tasksService.save(_selectedDate!, description);
      } else {
        setError('Data da task não selecionada');
      }
    } on Exception catch (e, s) {
      print(e);
      print(s);
      setError('Erro ao cadastrar Task');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
