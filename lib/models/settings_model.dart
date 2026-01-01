class SettingsModel {
  bool vibrationEnabled;
  bool soundEnabled;
  bool notificationsEnabled;
  String themeMode; // 'green', 'light', 'darkBlue'

  SettingsModel({
    this.vibrationEnabled = true,
    this.soundEnabled = false,
    this.notificationsEnabled = true,
    this.themeMode = 'green',
  });

  Map<String, dynamic> toJson() {
    return {
      'vibrationEnabled': vibrationEnabled,
      'soundEnabled': soundEnabled,
      'notificationsEnabled': notificationsEnabled,
      'themeMode': themeMode,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      soundEnabled: json['soundEnabled'] ?? false,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      themeMode: json['themeMode'] ?? 'green',
    );
  }
}
