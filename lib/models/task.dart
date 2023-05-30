import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String title;
  final String? content;
  final DateTime startDate;
  final DateTime dueDate;
  final bool isPinned;
  
  Task({this.isPinned=false, required this.title, required this.content,required this.dueDate, required this.startDate}):id=const Uuid().v4();
}

class TasksNotifier extends StateNotifier<List<Task>>{
  TasksNotifier():super([]);

  addToTasks(Task task){
    state = [task, ...state];
  }
  removeFromTasks(String taskId){
    state = state.where((element) => element.id != taskId).toList();
  }
}

final taskProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) => TasksNotifier());
