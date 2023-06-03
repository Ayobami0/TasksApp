import 'package:flutter/material.dart';
import 'package:tasks/widgets/custom_app_bar.dart';
import 'package:tasks/widgets/drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(activePage: 'Settings'),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            CustomAppBarWidget(scaffoldKey: _scaffoldKey,),
          ],
        ),
      ),
    );
  }
}
