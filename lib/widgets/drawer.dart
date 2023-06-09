
import 'package:flutter/material.dart';
import 'package:tasks/screens/home.dart';
import 'package:tasks/screens/settings.dart';

class CustomDrawer extends StatelessWidget {
  final String activePage;

  const CustomDrawer({super.key, required this.activePage});


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: CircleAvatar(),
          ),
          DrawerListTile(
            activePage: activePage,
            tileName: 'Tasks',
            iconData: Icons.task,
            onTap: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context)=>const HomeScreen())
              );
            },
          ),
          DrawerListTile(
            activePage: activePage,
            tileName: 'Settings',
            iconData: Icons.settings,
            onTap: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context)=>const SettingsScreen())
              );
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    this.onTap,
    required this.activePage,
    required this.tileName,
    required this.iconData,
  });

  final String activePage;
  final String tileName;
  final IconData iconData;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final activeTileColor = Theme.of(context).primaryColor;
    final activeTileTextColor = Theme.of(context).colorScheme.onPrimary;
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: ListTile(
        onTap: onTap,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30)
        )),
        textColor: activePage.toUpperCase() == tileName.toUpperCase() ? activeTileTextColor : null,
        iconColor: activePage.toUpperCase() == tileName.toUpperCase() ? activeTileTextColor : null,
        tileColor: activePage.toUpperCase() == tileName.toUpperCase() ? activeTileColor : null,
        title: Text(tileName),
        leading: Icon(iconData),
      ),
    );
  }
}
