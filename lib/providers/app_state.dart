import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/zikir_model.dart';
import '../models/settings_model.dart';

class AppState extends ChangeNotifier {
  List<ZikirModel> _zikirs = [];
  String? _activeZikirId;
  SettingsModel _settings = SettingsModel();

  // Getters
  List<ZikirModel> get zikirs => _zikirs;
  SettingsModel get settings => _settings;

  ZikirModel? get activeZikir {
    if (_activeZikirId == null)
      return _zikirs.isNotEmpty ? _zikirs.first : null;
    try {
      return _zikirs.firstWhere((z) => z.id == _activeZikirId);
    } catch (e) {
      return _zikirs.isNotEmpty ? _zikirs.first : null;
    }
  }

  // Initialization
  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Settings
    final settingsJson = prefs.getString('settings');
    if (settingsJson != null) {
      _settings = SettingsModel.fromJson(jsonDecode(settingsJson));
    }

    // Load Zikirs
    final zikirsJson = prefs.getStringList('zikirs');
    if (zikirsJson != null) {
      _zikirs = zikirsJson
          .map((str) => ZikirModel.fromJson(jsonDecode(str)))
          .toList();
    } else {
      // Default Initial Zikirs
      _zikirs = [
        ZikirModel(
          id: '1',
          title: 'Subhanallah',
          description: 'Glory be to Allah',
          targetCount: 100,
        ),
        ZikirModel(
          id: '2',
          title: 'Elhamdülillah',
          description: 'Praise be to Allah',
          targetCount: 100,
        ),
        ZikirModel(
          id: '3',
          title: 'Allahu Ekber',
          description: 'Allah is the Greatest',
          targetCount: 100,
        ),
      ];
    }

    _activeZikirId = prefs.getString('activeZikirId') ?? _zikirs.first.id;
    notifyListeners();
  }

  // Actions
  void setActiveZikir(String id) {
    _activeZikirId = id;
    _saveState();
    notifyListeners();
  }

  void incrementActiveZikir() {
    final zikir = activeZikir;
    if (zikir != null) {
      zikir.increment();
      _saveState(); // In a real app, maybe debounce this to avoid too many writes
      notifyListeners();
    }
  }

  void resetActiveZikir() {
    final zikir = activeZikir;
    if (zikir != null) {
      zikir.reset();
      _saveState();
      notifyListeners();
    }
  }

  void toggleVibration(bool value) {
    _settings.vibrationEnabled = value;
    _saveState();
    notifyListeners();
  }

  void toggleSound(bool value) {
    _settings.soundEnabled = value;
    _saveState();
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _settings.notificationsEnabled = value;
    _saveState();
    notifyListeners();
  }

  void setVibrationIntensity(double value) {
    _settings.vibrationIntensity = value;
    _saveState();
    notifyListeners();
  }

  void addZikir(String title, String description, int target) {
    final newZikir = ZikirModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      targetCount: target,
    );
    _zikirs.add(newZikir);
    _saveState();
    notifyListeners();
  }

  void deleteZikir(String id) {
    _zikirs.removeWhere((z) => z.id == id);
    // If deleted zikir was active, set first zikir as active
    if (_activeZikirId == id && _zikirs.isNotEmpty) {
      _activeZikirId = _zikirs.first.id;
    }
    _saveState();
    notifyListeners();
  }

  // Persistence
  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('settings', jsonEncode(_settings.toJson()));
    prefs.setStringList(
      'zikirs',
      _zikirs.map((z) => jsonEncode(z.toJson())).toList(),
    );
    if (_activeZikirId != null) {
      prefs.setString('activeZikirId', _activeZikirId!);
    }
  }
}
