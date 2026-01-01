import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final settings = appState.settings;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.settings, color: Colors.white),
                  const SizedBox(width: 8),
                  Text("Ayarlar", style: AppTextStyles.titleLarge),
                ],
              ),
              const SizedBox(height: 24),

              // Premium Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1C3A26), Color(0xFF112217)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Reklamsız Deneyim",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Daha odaklı bir zikir için Pro'ya geçin.",
                            style: TextStyle(
                              color: AppColors.textGray.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Reminders Section
              _SectionTitle(title: "Hatırlatıcılar"),
              _SettingsGroup(
                children: [
                  _SettingsSwitchTile(
                    icon: Icons.notifications_active,
                    iconColor: Colors.orange,
                    title: "Günlük Hatırlatıcı",
                    subtitle: "Zikir alışkanlığınızı koruyun",
                    value: settings.notificationsEnabled,
                    onChanged: (val) {
                      appState.toggleNotifications(val);
                    },
                  ),
                  const _Divider(),
                  _SettingsActionTile(
                    icon: Icons.schedule,
                    iconColor: Colors.blue,
                    title: "Hatırlatma Zamanı",
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "21:00",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Feedback & Control Section
              _SectionTitle(title: "Deneyim & Kontrol"),
              _SettingsGroup(
                children: [
                  _SettingsSwitchTile(
                    icon: Icons.vibration,
                    iconColor: Colors.teal,
                    title: "Titreşim",
                    value: settings.vibrationEnabled,
                    onChanged: (val) {
                      appState.toggleVibration(val);
                    },
                  ),
                  // Vibration Intensity Slider (shown when vibration is enabled)
                  if (settings.vibrationEnabled) ...[
                    const _Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(68, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Titreşim Seviyesi",
                                style: TextStyle(
                                  color: AppColors.textGray,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "${(settings.vibrationIntensity * 100).round()}%",
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: AppColors.primary.withOpacity(
                                0.2,
                              ),
                              thumbColor: AppColors.primary,
                              overlayColor: AppColors.primary.withOpacity(0.2),
                              trackHeight: 4,
                            ),
                            child: Slider(
                              value: settings.vibrationIntensity,
                              min: 0.0,
                              max: 1.0,
                              divisions: 10,
                              onChanged: (value) {
                                appState.setVibrationIntensity(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (!settings.vibrationEnabled) const _Divider(),
                  _SettingsSwitchTile(
                    icon: Icons.volume_up,
                    iconColor: Colors.pink,
                    title: "Ses Efekti",
                    value: settings.soundEnabled,
                    onChanged: (val) {
                      appState.toggleSound(val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Appearance Section
              _SectionTitle(title: "Görünüm"),
              _SettingsGroup(
                children: [
                  _SettingsActionTile(
                    icon: Icons.palette,
                    iconColor: Colors.grey,
                    title: "Tema Rengi",
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ColorCircle(
                          color: const Color(0xFF13EC5B),
                          isSelected: true,
                        ),
                        const SizedBox(width: 8),
                        _ColorCircle(
                          color: const Color(0xFF3B82F6),
                          isSelected: false,
                        ),
                        const SizedBox(width: 8),
                        _ColorCircle(
                          color: const Color(0xFF8B5CF6),
                          isSelected: false,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "Sürüm 1.4.2 (Build 204)",
                  style: TextStyle(color: AppColors.textGray, fontSize: 12),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textGray,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: AppColors.textGray,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}

class _SettingsActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget trailing;
  final VoidCallback onTap;

  const _SettingsActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Colors.white.withOpacity(0.05),
      indent: 68,
    );
  }
}

class _ColorCircle extends StatelessWidget {
  final Color color;
  final bool isSelected;
  const _ColorCircle({required this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: isSelected
          ? const Icon(Icons.check, color: Colors.black, size: 20)
          : null,
    );
  }
}
