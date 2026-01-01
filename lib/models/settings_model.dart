class SettingsModel {
  bool vibrationEnabled;
  bool soundEnabled;
  bool notificationsEnabled;
  double vibrationIntensity; // 0.0 to 1.0

  SettingsModel({
    this.vibrationEnabled = true,
    this.soundEnabled = false,
    this.notificationsEnabled = true,
    this.vibrationIntensity = 0.5, // Default to medium intensity
  });

  Map<String, dynamic> toJson() {
    return {
      'vibrationEnabled': vibrationEnabled,
      'soundEnabled': soundEnabled,
      'notificationsEnabled': notificationsEnabled,
      'vibrationIntensity': vibrationIntensity,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      soundEnabled: json['soundEnabled'] ?? false,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      vibrationIntensity:
          (json['vibrationIntensity'] as num?)?.toDouble() ?? 0.5,
    );
  }
}
