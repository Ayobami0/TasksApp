import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum TaskStatus {
  completed,pending,overdue
}

class Task {
  final String id;
  final String title;
  final String? content;
  final DateTime? startDate;
  final DateTime? dueDate;
  final bool isPinned;
  final TaskStatus status; 
  
  Task({this.isPinned=false, this.status=TaskStatus.pending, required this.id, required this.title, required this.content,required this.dueDate, required this.startDate});

  formatDueDate(){
    if(dueDate == null) return;
    return DateFormat.yMMMEd().add_jm().format(dueDate!);
  }
}

class TasksNotifier extends StateNotifier<List<Task>>{
  TasksNotifier():super([]);

  addToTasks(Task task){
    state = [task, ...state];
  }
  removeFromTasks(String taskId){
    state = state.where((element) => element.id != taskId).toList();
  }
  updateTaskStatus(String taskId, TaskStatus status){
    final task = state.singleWhere((element) => element.id == taskId);
    final newTask = Task(
      id: taskId,
      title: task.title,
      content: task.content,
      startDate: task.startDate,
      dueDate: task.dueDate,
      isPinned: task.isPinned,
      status: status
    );
    state = [
      for (final t in state) if(t.id != taskId) t,
      newTask
    ];
  }
}

final taskProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) => TasksNotifier());
