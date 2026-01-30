import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/todo_model.dart';
import 'package:taskat_new/data/repositories/todo_reposirory.dart';

class TodoProvider extends ChangeNotifier {
  TodoRepository _todoRepository;

  List<TodoModel> _todos = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentUserId;

  StreamSubscription<List<TodoModel>>? _todosSubscription;

  TodoProvider({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  void setRepository(TodoRepository repo) {
    _todoRepository = repo;
    stopListening(); 
  }

  List<TodoModel> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasActiveListener => _todosSubscription != null;

  void startListening(String userId) {
    if (_currentUserId == userId && _todosSubscription != null) return;

    _todosSubscription?.cancel();
    _currentUserId = userId;

    _setLoading(true);

    _todosSubscription = _todoRepository.getTodosStream(userId).listen(
      (todos) {
        _todos = todos;
        _setLoading(false);
      },
      onError: (error) {
        _errorMessage = error.toString();
        _todos = [];
        _setLoading(false);
      },
    );
  }

  void stopListening() {
    _todosSubscription?.cancel();
    _todosSubscription = null;
    _currentUserId = null;
    _todos = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> addTodo({
    required String userId,
    required String title,
  }) async {
    if (title.trim().isEmpty) {
      _errorMessage = 'Task cannot be empty';
      notifyListeners();
      return false;
    }

    try {
      final todo = TodoModel(
        id: '',
        userId: userId,
        title: title.trim(),
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await _todoRepository.addTodo(todo);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTodo(TodoModel todo) async {
    try {
      await _todoRepository.updateTodo(todo);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleTodo(TodoModel todo) async {
    await updateTodo(todo.copyWith(isCompleted: !todo.isCompleted));
  }

  Future<bool> deleteTodo(String todoId) async {
    try {
      await _todoRepository.deleteTodo(todoId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _todosSubscription?.cancel();
    super.dispose();
  }
}
