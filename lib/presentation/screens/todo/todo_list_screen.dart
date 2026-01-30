import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskat_new/l10n/app_localizations.dart';
import '../../../data/models/todo_model.dart';
import '../../../providers/todo_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/todo_item_widget.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen>
    with AutomaticKeepAliveClientMixin {
  final _taskController = TextEditingController();

  @override
  bool get wantKeepAlive => true; // Keep state when switching tabs

  @override
  void initState() {
    super.initState();
    debugPrint('🏠 TodoListScreen initState');

    // CRITICAL: Start listening after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeListener();
    });
  }

  void _initializeListener() {
    final authProvider = context.read<AuthProvider>();
    final todoProvider = context.read<TodoProvider>();

    final userId = authProvider.currentUser?.uid;

    if (userId != null) {
      debugPrint('👤 Current user ID: $userId');
      todoProvider.startListening(userId);
    } else {
      debugPrint('⚠️ No user ID found - cannot start listening');
    }
  }

  @override
  void dispose() {
    debugPrint('🧹 TodoListScreen dispose');
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    final l10n = AppLocalizations.of(context)!;

    if (_taskController.text.trim().isEmpty) {
      _showSnackBar(l10n.enterTask, Colors.orange);
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final todoProvider = context.read<TodoProvider>();
    final userId = authProvider.currentUser?.uid;

    if (userId == null) {
      _showSnackBar('User not authenticated', Colors.red);
      return;
    }

    debugPrint('➕ Adding task: ${_taskController.text.trim()}');

    final success = await todoProvider.addTodo(
      userId: userId,
      title: _taskController.text.trim(),
    );

    if (success) {
      _taskController.clear();
      FocusScope.of(context).unfocus();
      _showSnackBar(l10n.taskAdded, Colors.green, icon: Icons.check_circle);
    } else {
      _showSnackBar(
        todoProvider.errorMessage ?? 'Failed to add task',
        Colors.red,
        icon: Icons.error,
      );
    }
  }

  void _showSnackBar(String message, Color color, {IconData? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _editTask(TodoModel todo) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: todo.title);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editTask),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.enterTask,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && result != todo.title) {
      final todoProvider = context.read<TodoProvider>();
      final success = await todoProvider.updateTodo(
        todo.copyWith(title: result),
      );

      _showSnackBar(
        success ? l10n.taskUpdated : 'Failed to update',
        success ? Colors.green : Colors.red,
        icon: success ? Icons.check_circle : Icons.error,
      );
    }
  }

  Future<void> _deleteTask(TodoModel todo) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTask),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to delete this task?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                todo.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final todoProvider = context.read<TodoProvider>();
      final success = await todoProvider.deleteTodo(todo.id);

      _showSnackBar(
        success ? l10n.taskDeleted : 'Failed to delete',
        success ? Colors.green : Colors.red,
        icon: success ? Icons.check_circle : Icons.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    final l10n = AppLocalizations.of(context)!;
    final todoProvider = context.watch<TodoProvider>();

    final completedCount =
        todoProvider.todos.where((t) => t.isCompleted).length;
    final totalCount = todoProvider.todos.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todoList),
        actions: [
          // Debug info
          if (kDebugMode)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Icon(
                  todoProvider.hasActiveListener ? Icons.wifi : Icons.wifi_off,
                  color: todoProvider.hasActiveListener
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          // Task counter
          if (totalCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$completedCount/$totalCount',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Add Task Input
          _buildAddTaskSection(l10n),

          // Task List
          Expanded(
            child: _buildTaskList(todoProvider, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTaskSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _taskController,
              decoration: InputDecoration(
                hintText: l10n.addTask,
                prefixIcon: const Icon(Icons.add_task),
              ),
              onSubmitted: (_) => _addTask(),
              textInputAction: TextInputAction.done,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _addTask,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Icon(Icons.add, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(TodoProvider todoProvider, AppLocalizations l10n) {
    if (todoProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (todoProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
            const SizedBox(height: 16),
            const Text('Error loading tasks', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                todoProvider.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _initializeListener,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (todoProvider.todos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              l10n.noTasks,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Start by adding a new task above',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: todoProvider.todos.length,
      itemBuilder: (context, index) {
        final todo = todoProvider.todos[index];
        return TodoItemWidget(
          todo: todo,
          onToggle: () => todoProvider.toggleTodo(todo),
          onDelete: () => _deleteTask(todo),
          onEdit: () => _editTask(todo),
        );
      },
    );
  }
}
