import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../models/task.dart";

class StatusCountWidget extends ConsumerWidget {
  final String status;
  final TaskStatus taskStatus;
  final IconData icon;

  const StatusCountWidget({super.key, required this.status, required this.taskStatus, required this.icon});

  @override
  Widget build(BuildContext context, ref) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(status),
            Icon(icon),
            Text(ref.watch(taskProvider).where((element) => element.status == taskStatus).length.toString(), style: const TextStyle(fontSize: 20),)
          ],
        ),
      ),
    );
  }
}
