import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/widgets/delete_dialog.dart';
import 'package:tasks/widgets/task_details_popup.dart';

class TaskTile extends ConsumerWidget {
  final Task task;
  const TaskTile({required super.key, required this.task});

  @override
  Widget build(BuildContext context, ref) {
    return Card(
      elevation: 4,
      child: Dismissible(
        // dismissThresholds: const {DismissDirection.endToStart: 0.5},
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
          ref.read(taskProvider.notifier).removeFromTasks(task.id);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task deleted!')));
        },
        key: key!,
        child: ListTile(
          onTap: (){
            showTaskPopUp(context, task, ref);
          },
          title: Text(task.title,),
          subtitle: Row(
            children: [
              const Icon(Icons.schedule),
              const SizedBox(width: 10,),
              if (task.status == TaskStatus.pending) Text('Due At: ${task.formatDueDate() ?? "-"}')
              else if(task.status == TaskStatus.completed) const Text('Task Completed')
              else const Text('Task Expired')
            ],
          ),
          trailing: task.status == TaskStatus.pending ? IconButton(
            onPressed: (){
              ref.read(taskProvider.notifier).updateTaskStatus(task.id, TaskStatus.completed);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task completed!')));
            },
            icon: const Icon(Icons.check)
          ) : task.status == TaskStatus.completed 
          ? const Icon(Icons.task_alt, color: Colors.green,) 
          : const Icon(Icons.block, color: Colors.red,),
        ),
      ),
    );
  }
}
