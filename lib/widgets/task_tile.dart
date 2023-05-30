import 'package:flutter/material.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/widgets/delete_dialog.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 0),
            blurRadius: 3,
            spreadRadius: 1
          ),
        ],
        borderRadius: BorderRadius.circular(4)
      ),
      child: Dismissible(
        secondaryBackground: Container(
          padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4)
      ),
          alignment: Alignment.centerRight, 
          child: const Icon(Icons.delete)
        ),
        background: Container(),
        direction: DismissDirection.endToStart,
        onDismissed: (_){
          showDeleteDialog(context);
        },
        key: key!,
        child: ListTile(
          tileColor: Theme.of(context).colorScheme.surface,
          title: Text(task.title),
          trailing: FittedBox(
            child: IconButton(
              onPressed: (){},
              icon: const Icon(Icons.check)
            ),
          ),
        ),
      ),
    );
  }
}
