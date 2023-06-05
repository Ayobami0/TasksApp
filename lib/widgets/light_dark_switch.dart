import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/providers/brightness.dart';

import '../providers/shared_utility.dart.dart';


class LightDarkSwitch extends ConsumerWidget {
  LightDarkSwitch({
    super.key,
    this.showIcons = true,
  });

  final bool showIcons;

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
      thumbIcon: showIcons ? thumbIcon : null,
      value: isDark,
      onChanged: (value){
        ref.read(brightnessProvider.notifier).toggleDarkMode();
      },
    );
  }
}
