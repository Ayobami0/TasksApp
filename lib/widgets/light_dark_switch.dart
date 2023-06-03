import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/mode.dart';

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
