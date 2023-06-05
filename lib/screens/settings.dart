import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/providers/reminder.dart';
import 'package:tasks/widgets/custom_app_bar.dart';
import 'package:tasks/widgets/drawer.dart';
import 'package:tasks/widgets/light_dark_switch.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  
  @override
  Widget build(BuildContext context) {

  final List<DropdownMenuItem<ReminderTime>> dropdownMenuItems = [];
  
  for (final ReminderTime item in ReminderTime.values) {
    dropdownMenuItems.add(
      DropdownMenuItem(
        value: item,
        child: Text(item.label)
      )
    );
  }
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(activePage: 'Settings'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              CustomAppBarWidget(scaffoldKey: _scaffoldKey, showBrightnessSwitch: false,),
              const Align(
                alignment: Alignment.centerLeft, child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24
                  ),
                )
              ),
              const SizedBox(height: 15,),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Switch Modes'),
                      trailing: LightDarkSwitch(showIcons: false,),
                    ),
                    SwitchListTile(
                      title: const Text('Remind tasks'),
                      onChanged: (value){
                        ref.read(remindProvider.notifier).toggleRemind();
                      },
                      value: ref.watch(remindProvider),
                    ),
                    ListTile(
                      title: const Text('Remind me when'),
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(20),
                          onChanged: ((ReminderTime? remiderTime){
                            ref.read(reminderTimeProvider.notifier).changeReminderTime(
                              remiderTime!.time
                            );
                          }),
                          value: ReminderTime.values.singleWhere(
                          (element) => element.time == ref.watch(reminderTimeProvider)),
                          items: ref.watch(remindProvider) 
                          ? dropdownMenuItems
                          : null,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
enum ReminderTime {
  remindIn15Mins(15, '15mins to deadline'),
  remindIn30Mins(30, '30mins to deadline'),
  remindIn1Hour(60, '1hrs to deadline'),
  remindIn12Hours(12*60, '12hrs to deadline'),
  remindIn1day(60*24, '1day to deadline'),
  remindIn1week(7*60*24, '1week to deadline');
  
  const ReminderTime(this.time, this.label);
  final int time;
  final String label;
}
