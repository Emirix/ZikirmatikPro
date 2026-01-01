import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/main_scaffold.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  await appState.loadState();

  runApp(
    ChangeNotifierProvider(
      create: (context) => appState,
      child: const ZikirmatikApp(),
    ),
  );
}

class ZikirmatikApp extends StatelessWidget {
  const ZikirmatikApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final hasCompletedOnboarding = appState.hasCompletedOnboarding;

    // Map theme string to enum
    AppThemeMode themeMode;
    switch (appState.settings.themeMode) {
      case 'light':
        themeMode = AppThemeMode.light;
        break;
      case 'darkBlue':
        themeMode = AppThemeMode.darkBlue;
        break;
      default:
        themeMode = AppThemeMode.green;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zikirmatik Pro',
      theme: AppTheme.getTheme(themeMode).toThemeData(),
      home: hasCompletedOnboarding
          ? const MainScaffold()
          : const OnboardingScreen(),
      routes: {'/home': (context) => const MainScaffold()},
    );
  }
}
