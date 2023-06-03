import 'package:flutter/material.dart';

class DrawerOpener extends StatelessWidget {
  const DrawerOpener({
    required this.scaffoldKey,
    super.key,
  });

  final GlobalKey<ScaffoldState> scaffoldKey; 

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        scaffoldKey.currentState!.openDrawer();
      }, 
      icon: const Icon(Icons.menu_rounded)
    );
  }
}
