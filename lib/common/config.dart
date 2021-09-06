class Config {
  Config._();

  static Duration getNotificationInterval() {
    return Duration(days: 1);
  }

  static String getNotificationTime() {
    return "11:00:00";
  }
}
