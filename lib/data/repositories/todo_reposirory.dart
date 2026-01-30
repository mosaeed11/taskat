import '../models/todo_model.dart';
import '../services/firebase_firestore_service.dart';

class TodoRepository {
  final FirebaseFirestoreService _firestoreService;

  TodoRepository({required FirebaseFirestoreService firebaseFirestoreService})
      : _firestoreService = firebaseFirestoreService;

  Stream<List<TodoModel>> getTodosStream(String userId) {
    return _firestoreService.getTodosStream(userId);
  }

  Future<void> addTodo(TodoModel todo) async {
    await _firestoreService.addTodo(todo);
  }

  Future<void> updateTodo(TodoModel todo) async {
    await _firestoreService.updateTodo(todo);
  }

  Future<void> deleteTodo(String todoId) async {
    await _firestoreService.deleteTodo(todoId);
  }
}
