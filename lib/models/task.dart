import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tasks/models/database.dart';

enum TaskStatus {
  completed,pending,overdue
}

class Task {
  final String id;
  final String title;
  final String? content;
  final DateTime startDate;
  final DateTime? dueDate;
  final bool isPinned;
  final TaskStatus status; 
  
  Task({this.isPinned=false, this.status=TaskStatus.pending, required this.id, required this.title, required this.content,required this.dueDate, required this.startDate});

  factory Task.fromJson(Map<String, dynamic> json){
    return Task(
      id: json['id'],
      title: json['title'],
      content: json['description'],
      startDate: DateTime.parse(json['createdOn']),
      status: TaskStatus.values.singleWhere((element) => element.name == json['status']),
      isPinned: json['isPinned'] == 1,
      dueDate: DateTime.tryParse(json['expiresOn'] ?? ''),
    );
  }
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'description': content,
      'expiresOn': dueDate?.toIso8601String(),
      'createdOn': startDate.toIso8601String(),
      'status': status.name,
      'isPinned': isPinned ? 1 : 0,
    };
  }

  formatDueDate(){
    if(dueDate == null) return;
    return DateFormat.yMMMEd().add_jm().format(dueDate!);
  }
  formatCreatedDate(){
    return DateFormat.yMMMEd().add_jm().format(startDate);
  }
}

class TasksNotifier extends StateNotifier<List<Task>>{
  TasksNotifier():super([]);
  
  Future readFromDB() async{
    state = await DatabaseRepository.query();
  }
  Future addToTasks(Task task) async{
    // state = [task, ...state];
    await DatabaseRepository.insert(task);
    await readFromDB();
  }
  Future removeFromTasks(String taskId) async{
    // state = state.where((element) => element.id != taskId).toList();
    await DatabaseRepository.delete(taskId);
    await readFromDB();
  }
  Future updateTaskStatus(String taskId, TaskStatus status) async{
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
    // state = [
    //   for (final t in state) if(t.id != taskId) t,
    //   newTask
    // ];
    await DatabaseRepository.update(newTask);
    await readFromDB();
  }
}

final taskProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) => TasksNotifier());
