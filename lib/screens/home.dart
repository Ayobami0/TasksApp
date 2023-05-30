import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/widgets/floating_action_button.dart';
import 'package:tasks/widgets/task_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final taskList = ref.watch(taskProvider);
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(onPressed: (){}),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 0),
                      blurRadius: 2,
                      spreadRadius: 2
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8)
                  )
                ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: taskList.isEmpty ? Column(
                  children: [
                    Text('You have no tasks!')
                  ],
                )  : ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (ctx, idx)=>TaskTile(task: taskList[idx]),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
