import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/providers/shared_utility.dart.dart';

class RemindTaskDeadlineNotifier extends StateNotifier<bool>{
  RemindTaskDeadlineNotifier({required this.ref}):super(
    ref.watch(sharedUtilityProvider).getRemindStatus()
  );
  final Ref ref;

  toggleRemind(){
    ref.read(sharedUtilityProvider).remindTask(!ref.watch(sharedUtilityProvider).getRemindStatus());
    state = ref.watch(sharedUtilityProvider).getRemindStatus();
  }
}

class RemindTimeNotifier extends StateNotifier<int>{
  RemindTimeNotifier({required this.ref}):super(
    ref.watch(sharedUtilityProvider).getReminderTime()
  );
  final Ref ref;

  changeReminderTime(int newTime){
    ref.read(sharedUtilityProvider).changeReminder(newTime);
    state = ref.watch(sharedUtilityProvider).getReminderTime();
  }
}


final reminderTimeProvider = StateNotifierProvider<RemindTimeNotifier, int>((ref){
  return RemindTimeNotifier(ref: ref);
});


final remindProvider = StateNotifierProvider<RemindTaskDeadlineNotifier, bool>((ref){
  return RemindTaskDeadlineNotifier(ref: ref);
});
