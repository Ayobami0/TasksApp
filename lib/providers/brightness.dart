import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/providers/shared_utility.dart.dart';

final brightnessProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref){
  return DarkModeNotifier(ref: ref);
});

class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier(
    {required this.ref}
  ):super(ref.watch(sharedUtilityProvider).getBrightness());
  
  final Ref ref;

  toggleDarkMode(){
    ref.read(sharedUtilityProvider).changeBrightness(
      !ref.watch(sharedUtilityProvider).getBrightness()
    );
    state = ref.watch(sharedUtilityProvider).getBrightness();
  }
}
