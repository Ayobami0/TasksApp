import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/widgets/floating_action_button.dart';
import 'package:tasks/widgets/task_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<TaskStatus> _filter = [];

  // filter(){
  //   if (filter.isEmpty) {
  //     _taskList = ref.watch(taskProvider);
  //     return;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
  List<Task> taskList = ref.watch(taskProvider);
                    final displayedList = _filter.isEmpty ?  taskList : 
                      taskList.where((element) => _filter.contains(element.status)).toList()
                    ;
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(onPressed: (){}),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Row(
                children: const [
                  Expanded(child: StatusCountWidget(status: 'COMPETED', taskStatus: TaskStatus.completed, icon: Icons.task_alt)),
                  Expanded(child: StatusCountWidget(status: 'PENDING', taskStatus: TaskStatus.pending, icon: Icons.pending)),
                  Expanded(child: StatusCountWidget(status: 'EXPIRED', taskStatus: TaskStatus.overdue, icon: Icons.block)),
                ],
              ),
              const SizedBox(height: 10,),
              // Align(
              //   alignment: Alignment.centerRight, 
              //   child: IconButton(
              //     onPressed: (){
              //     },
              //     icon: const Icon(Icons.filter_list),
              //   ),
              // ),
              Wrap(
                children: TaskStatus.values.map(
                (e) {
                  return FilterChip(
                      label: Text(e.name),
                      selected: _filter.contains(e),
                      onSelected: (bool selected){
                        if (selected) {
                          setState(() {
                          _filter.add(e);
                                                    });
                        } else {
                          setState(() {
                          _filter.remove(e);
                                                    });
                        }
                      },
                    );
                  }).toList(),
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: displayedList.isEmpty ? Column(
                  children: const [
                    Text('You have no tasks!')
                  ],
                )  : ListView.separated(
                  separatorBuilder: (context, idx) =>const SizedBox(height: 10),
                  itemCount: displayedList.length,
                  itemBuilder: (ctx, idx){
                    return TaskTile(
                      task: displayedList[idx], 
                      key: UniqueKey(),
                    );
                  }
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

class StatusCountWidget extends ConsumerWidget {
  final String status;
  final TaskStatus taskStatus;
  final IconData icon;

  const StatusCountWidget({super.key, required this.status, required this.taskStatus, required this.icon});

  @override
  Widget build(BuildContext context, ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(status),
            Icon(icon),
            Text(ref.watch(taskProvider).where((element) => element.status == taskStatus).length.toString())
          ],
        ),
      ),
    );
  }
}
