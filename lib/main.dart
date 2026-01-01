import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/main_scaffold.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'theme/app_colors.dart';

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
    final hasCompletedOnboarding = context
        .watch<AppState>()
        .hasCompletedOnboarding;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zikirmatik Pro',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        brightness: Brightness.dark,
      ),
      home: hasCompletedOnboarding
          ? const MainScaffold()
          : const OnboardingScreen(),
      routes: {'/home': (context) => const MainScaffold()},
    );
  }
}
