import 'package:flutter/material.dart';
import 'package:tasks/widgets/custom_app_bar.dart';
import 'package:tasks/widgets/drawer.dart';
import 'package:tasks/widgets/light_dark_switch.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _remindTask = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<DropdownMenuEntry> _dropdownMenuEntries = const [
    DropdownMenuEntry(
      value: '1h',
      label: '1h to deadline'
    ),
  ];
  @override
  Widget build(BuildContext context) {
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
                      trailing: LightDarkSwitch(),
                    ),
                    SwitchListTile(
                      title: const Text('Remind tasks'),
                      onChanged: (value){
                        setState(() {
                                                  _remindTask = value;
                                                });
                      },
                      value: _remindTask,
                    ),
                    ListTile(
                      title: const Text('Remind me when'),
                      trailing: DropdownMenu(
                        enabled: _remindTask,
                        enableSearch: false,
                        dropdownMenuEntries: _dropdownMenuEntries
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
