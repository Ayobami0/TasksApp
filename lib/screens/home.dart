import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/widgets/floating_action_button.dart';
import 'package:tasks/widgets/task_tile.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/drawer.dart';
import '../widgets/status_count_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<TaskStatus> _filter = [];
  final _key = GlobalKey<ScaffoldState>();
  
  @override
    void initState() {
      super.initState();
      ref.read(taskProvider.notifier).readFromDB();
    }
  @override
  Widget build(BuildContext context) {
  final List<Task> taskList = ref.watch(taskProvider);
  final displayedList = _filter.isEmpty ?  taskList : 
    taskList.where((element) => _filter.contains(element.status)).toList();
    return Scaffold(
      key: _key,
      floatingActionButton: CustomFloatingActionButton(onPressed: (){}),
      drawer: const CustomDrawer(activePage: 'tasks'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              CustomAppBarWidget(scaffoldKey: _key),
              Row(
                children: const [
                  Expanded(child: StatusCountWidget(status: 'COMPLETED', taskStatus: TaskStatus.completed, icon: Icons.task_alt)),
                  Expanded(child: StatusCountWidget(status: 'PENDING', taskStatus: TaskStatus.pending, icon: Icons.pending)),
                  Expanded(child: StatusCountWidget(status: 'EXPIRED', taskStatus: TaskStatus.overdue, icon: Icons.block)),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('You have no tasks!')
                  ],
                )  : ListView.separated(
                  separatorBuilder: (context, idx) =>const SizedBox(height: 10),
                  itemCount: displayedList.length,
                  itemBuilder: (ctx, idx){
                    return TaskTile(
                      task: displayedList[idx], 
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
