
import 'package:flutter/material.dart';

import 'drawer_open_button.dart';
import 'light_dark_switch.dart';

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DrawerOpener(scaffoldKey: scaffoldKey),
        LightDarkSwitch(),
      ],
    );
  }
}
