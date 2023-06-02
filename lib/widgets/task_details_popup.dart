import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/widgets/delete_dialog.dart';

showTaskPopUp(BuildContext context, Task task, WidgetRef ref){
  final Map<TaskStatus, Map<String, dynamic>> status = {
  TaskStatus.completed: {'text':'COMPLETED', 'color': Colors.green},
  TaskStatus.pending: {'text':'PENDING', 'color': Colors.yellow},
  TaskStatus.overdue: {'text':'EXPIRED', 'color': Colors.red},
};
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: 'close',
    context: context, 
    pageBuilder: (ctx, ai, a2){
      return ScaleTransition(
        scale: Tween<double>(begin: 0, end: 1).animate(ai),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SingleChildScrollView(
            child: SizedBox(
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          task.title,
                          style: Theme.of(ctx).textTheme.titleLarge,
                        ),
                        IconButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, icon: const Icon(Icons.close))
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      'Created on: ${task.formatCreatedDate()}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      'Due on: ${task.formatDueDate() ?? "No Expiration"}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 5,),
                    Text('Status: ${status[task.status]!["text"]}', 
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 15,),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Comment',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              task.content ?? '',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: task.status != TaskStatus.pending ? null : (){},
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)
                              ))
                            ),
                            child: task.status == TaskStatus.overdue ? const Icon(Icons.block) : task.status == TaskStatus.completed ? const Icon(Icons.task_alt) : const Text('Complete'),
                          ),
                        ),
                        IconButton(
                          onPressed: () async{
                            await showDeleteDialog(ctx).then((value){
                              if (!value) return;
                              Navigator.of(ctx).pop();
                              ref.read(taskProvider.notifier).removeFromTasks(task.id);
                              ScaffoldMessenger.of(ctx).clearSnackBars();
                              ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Task deleted!')));
                            });
                          },
                          icon: const Icon(Icons.delete, color: Colors.red,)
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  );
}
