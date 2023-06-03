import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/widgets/delete_dialog.dart';

showTaskPopUp(BuildContext context, String taskId){
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: 'close',
    context: context, 
    pageBuilder: (context, a1, a2){
      return TaskDialogWidget(taskId: taskId, a1: a1, a2: a2);
    }
  );
}

class TaskDialogWidget extends ConsumerWidget {
  final String taskId;
  final Animation<double> a1;
  final Animation<double> a2;
  const TaskDialogWidget({
    super.key,
    required this.a1,
    required this.a2,
    required this.taskId,
  });

  final Map<TaskStatus, Map<String, dynamic>> _status = const {
    TaskStatus.completed: {'text':'COMPLETED', 'color': Colors.green},
    TaskStatus.pending: {'text':'PENDING', 'color': Colors.yellow},
    TaskStatus.overdue: {'text':'EXPIRED', 'color': Colors.red},
  };

  @override
  Widget build(BuildContext context, ref) {
  final task = ref.watch(taskProvider).singleWhere((t)=>t.id == taskId);
    return ScaleTransition(
      scale: Tween<double>(begin: 0, end: 1).animate(a1),
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
                        style: Theme.of(context).textTheme.titleLarge,
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
                  Text('Status: ${_status[task.status]!["text"]}', 
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 15,),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
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
                          onPressed: task.status != TaskStatus.pending ? null 
                          : (){
                            ref.read(taskProvider.notifier).updateTaskStatus(
                              task.id, 
                              TaskStatus.completed
                            );
                          },
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
                          await showDeleteDialog(context).then((value){
                            if (!value) return;
                            Navigator.of(context).pop();
                            ref.read(taskProvider.notifier).removeFromTasks(task.id);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task deleted!')));
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
}
