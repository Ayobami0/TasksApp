import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/providers/mode.dart';
import 'package:tasks/widgets/floating_action_button.dart';
import 'package:tasks/widgets/task_tile.dart';

import '../widgets/status_count_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<TaskStatus> _filter = [];
  @override
  Widget build(BuildContext context) {
  final List<Task> taskList = ref.watch(taskProvider);
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
              Align(
                alignment: Alignment.centerRight,
                child: LightDarkSwitch(),
              ),
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

class LightDarkSwitch extends ConsumerWidget {
  LightDarkSwitch({
    super.key,
  });

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.dark_mode);
      }
      return const Icon(Icons.light_mode);
    },
  );

  @override
  Widget build(BuildContext context, ref) {
    final isDark = ref.watch(brightnessProvider);
    return Switch(
      thumbIcon: thumbIcon,
      value: isDark,
      onChanged: (value){
        ref.read(brightnessProvider.notifier).changeMode();
      },
    );
  }
}
