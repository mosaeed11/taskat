import 'package:flutter/material.dart';
import '../../data/models/todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: todo.isCompleted 
              ? Colors.green.withOpacity(0.6)
              : Colors.transparent,
          width: 2,
        ),
      ),
      // GREEN background when completed
      color: todo.isCompleted
          ? (isDark 
              ? Colors.green.shade900.withOpacity(0.2) 
              : Colors.green.shade50)
          : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        
        // CHECKBOX
        leading: Transform.scale(
          scale: 1.3,
          child: Checkbox(
            value: todo.isCompleted,
            onChanged: (_) => onToggle(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            activeColor: Colors.green,
            side: BorderSide(
              color: todo.isCompleted ? Colors.green : Colors.grey,
              width: 2,
            ),
          ),
        ),
        
        // TASK TITLE with STRIKETHROUGH when completed
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: todo.isCompleted ? FontWeight.normal : FontWeight.w500,
            // GREEN color and STRIKETHROUGH when completed
            color: todo.isCompleted 
                ? Colors.green.shade700
                : null,
            decoration: todo.isCompleted 
                ? TextDecoration.lineThrough 
                : TextDecoration.none,
            decorationThickness: 2.5,
            decorationColor: Colors.green.shade600,
          ),
        ),
        
        // Date and completion badge
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Icon(Icons.access_time, size: 13, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _formatDate(todo.createdAt),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              if (todo.isCompleted) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 12, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // EDIT and DELETE buttons
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              color: Colors.blue.shade600,
              iconSize: 22,
              onPressed: onEdit,
              tooltip: 'Edit task',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red.shade600,
              iconSize: 22,
              onPressed: onDelete,
              tooltip: 'Delete task',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays == 0) {
      return 'Today ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}