import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get real-time stream of todos for a user
  Stream<List<TodoModel>> getTodosStream(String userId) {
    debugPrint('🔥 Creating Firestore stream for userId: $userId');

    return _firestore
        .collection('todos')
        .where('userId', isEqualTo: userId) // ← CRITICAL: Filter by user
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      debugPrint(
          '📦 Firestore snapshot received: ${snapshot.docs.length} documents');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        debugPrint(
            '  - Doc: ${doc.id}, userId: ${data['userId']}, title: ${data['title']}');
        return TodoModel.fromFirestore(data, doc.id);
      }).toList();
    }).handleError((error) {
      debugPrint('❌ Firestore stream error: $error');
      throw error;
    });
  }

  /// Add todo to Firestore
  Future<void> addTodo(TodoModel todo) async {
    debugPrint('💾 Saving todo to Firestore: ${todo.id}');
    await _firestore
        .collection(AppConstants.todosCollection)
        .doc(todo.id)
        .set(todo.toMap());
    debugPrint('✅ Todo saved successfully');
  }

  /// Update existing todo
  Future<void> updateTodo(TodoModel todo) async {
    await _firestore
        .collection(AppConstants.todosCollection)
        .doc(todo.id)
        .update(todo.toMap());
  }

  /// Delete todo
  Future<void> deleteTodo(String todoId) async {
    await _firestore
        .collection(AppConstants.todosCollection)
        .doc(todoId)
        .delete();
  }

  /// Get user data from Firestore
  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  /// Create user in Firestore
  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  /// Get todos for a user (non-stream version)
  Future<List<TodoModel>> getTodos(String userId) async {
    final snapshot = await _firestore
        .collection('todos')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => TodoModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
