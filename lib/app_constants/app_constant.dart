class AppConstant {

  static const String tableName = 'tasksTable';
  // Database colomn names
  static const String id = 'id';
  static const String title = 'title';
  static const String description = 'description';
  static const String isPinned = 'isPinned';
  static const String status = 'status';
  static const String createdOn = 'createdOn';
  static const String expiresOn = 'expiresOn';

  // SharedPreferences Keys
  static const String brightnessModeKey = 'brightnessMode';
  static const String reminderTimeKey = 'remindWhen';
  static const String remindTaskKey = 'remindTask';

  // App defaults
  static const bool remindTask = true; // remind task by default
  static const int reminderTime = 30; // in mins 
}
