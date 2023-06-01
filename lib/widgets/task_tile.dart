import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/widgets/delete_dialog.dart';

class TaskTile extends ConsumerWidget {
  final Task task;
  const TaskTile({required super.key, required this.task});

  @override
  Widget build(BuildContext context, ref) {
    return Card(
      elevation: 4,
      child: Dismissible(
        background: Container(
          padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(2)
      ),
          alignment: Alignment.centerRight, 
          child: const Icon(Icons.delete)
        ),
        // background: Container(),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async{
          return await showDeleteDialog(context);
        },
        onDismissed: (_){
          ref.watch(taskProvider.notifier).removeFromTasks(task.id);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task deleted!')));
        },
        key: key!,
        child: ListTile(
          title: Text(task.title,),
          subtitle: Row(
            children: [
              const Icon(Icons.schedule),
              Text('Due At: ${task.dueDate ?? "-"}')
            ],
          ),
          trailing: task.status != TaskStatus.completed ? IconButton(
            onPressed: (){
              ref.watch(taskProvider.notifier).updateTaskStatus(task.id, TaskStatus.completed);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task completed!')));
            },
            icon: const Icon(Icons.check)
          ) : const Icon(Icons.task_alt, color: Colors.green,),
        ),
      ),
    );
  }
}
