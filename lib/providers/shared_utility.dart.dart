import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks/app_constants/app_constant.dart';

class SharedUtility {
   final SharedPreferences sharedPreference;

  
  SharedUtility(
    {required this.sharedPreference}
  );

  bool getBrightness(){
    return sharedPreference.getBool(AppConstant.brightnessModeKey) ?? false;
  }
  int getReminderTime(){
    return sharedPreference.getInt(AppConstant.reminderTimeKey) ?? AppConstant.reminderTime;
  }
  bool getRemindStatus(){
    return sharedPreference.getBool(AppConstant.remindTaskKey) ?? AppConstant.remindTask;
  }

  void changeBrightness(bool isDark){
    sharedPreference.setBool(AppConstant.brightnessModeKey, isDark);
  }
  void changeReminder(int reminderTime){
    sharedPreference.setInt(AppConstant.reminderTimeKey, reminderTime);
  }
  void remindTask(bool remind){
    sharedPreference.setBool(AppConstant.remindTaskKey, remind);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref){
  throw UnimplementedError();
});

final sharedUtilityProvider = Provider<SharedUtility>((ref){
    final SharedPreferences pref = ref.watch(sharedPreferencesProvider);
    return SharedUtility(sharedPreference: pref);
  });
