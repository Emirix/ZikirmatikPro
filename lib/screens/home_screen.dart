import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/top_bar_button.dart';
import '../widgets/counter_button.dart';
import '../widgets/progress_bar.dart';
import 'main_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  void _playClickSound() {
    // Play system click sound
    SystemSound.play(SystemSoundType.click);
  }

  int? _previousCounter;
  bool _shouldAnimate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = context.watch<AppState>();
    final currentCounter = appState.activeZikir?.currentCount ?? 0;

    // Trigger animation when counter changes
    if (_previousCounter != null && _previousCounter != currentCounter) {
      setState(() => _shouldAnimate = true);
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) setState(() => _shouldAnimate = false);
      });
    }
    _previousCounter = currentCounter;
  }

  @override
  Widget build(BuildContext context) {
    // Watch AppState for changes
    final appState = context.watch<AppState>();
    final activeZikir = appState.activeZikir;
    final counter = activeZikir?.currentCount ?? 0;
    final target = activeZikir?.targetCount ?? 100;
    final title = activeZikir?.title ?? "Subhanallah";
    final description = activeZikir?.description ?? "Glory be to Allah";

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Stack(
          children: [
            // Background visual glow (prominent green circle in center)
            /* Positioned.fill(
              child: Center(
                child: Container(
                  width: 250,
                  height: 250,

                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 100,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
      */
            Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Positioned(
                        left: 12,
                        child: IconButton(
                          icon: const Icon(Icons.restart_alt, size: 32),
                          color: AppColors.textWhite,
                          onPressed: () async {
                            // Show confirmation dialog
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.surfaceDark,
                                title: const Text(
                                  "Sıfırla",
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: const Text(
                                  "Sayacı sıfırlamak istediğinizden emin misiniz?",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text("İptal"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                    ),
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text(
                                      "Sıfırla",
                                      style: TextStyle(
                                        color: AppColors.backgroundDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              // Check vibration setting before haptic feedback
                              if (appState.settings.vibrationEnabled) {
                                HapticFeedback.mediumImpact();
                              }
                              context.read<AppState>().resetActiveZikir();
                            }
                          },
                        ),
                      ),
                      Text("ZIKIRMATIK", style: AppTextStyles.headerTitle),
                      TopBarButton(
                        icon: Icons.settings,
                        onPressed: () {
                          // Navigate to Settings tab (index 3)
                          final scaffoldState = context
                              .findRootAncestorStateOfType<
                                State<MainScaffold>
                              >();
                          if (scaffoldState != null) {
                            (scaffoldState as dynamic).changeTab(3);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title Section
                        Column(
                          children: [
                            Text(title, style: AppTextStyles.titleLarge),
                            if (description.isNotEmpty) ...[
                              const SizedBox(height: 9),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceDark,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  description,
                                  style: AppTextStyles.pillText,
                                ),
                              ),
                            ],
                          ],
                        ),

                        // Main Counter (centered in middle)
                        Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 100,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedScale(
                                scale: _shouldAnimate ? 1.1 : 1.0,
                                duration: const Duration(milliseconds: 200),

                                curve: Curves.easeInOut,
                                child: Text(
                                  "$counter",
                                  style: AppTextStyles.displayHuge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                "Zikir",
                                style: AppTextStyles.labelMedium.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Progress and Controls at bottom
                        Column(
                          children: [
                            ProgressBar(current: counter, target: target),
                            const SizedBox(height: 32),

                            // Interaction Area
                            Container(
                              height: 140,
                              width: double.infinity,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CounterButton(
                                    onPressed: () {
                                      // Check vibration setting before haptic feedback
                                      if (appState.settings.vibrationEnabled) {
                                        final intensity = appState
                                            .settings
                                            .vibrationIntensity;
                                        // Map intensity to different haptic feedback types
                                        if (intensity < 0.33) {
                                          HapticFeedback.selectionClick(); // Light
                                        } else if (intensity < 0.66) {
                                          HapticFeedback.lightImpact(); // Medium
                                        } else {
                                          HapticFeedback.mediumImpact(); // Strong
                                        }
                                      }

                                      // Check sound setting before playing sound
                                      if (appState.settings.soundEnabled) {
                                        _playClickSound();
                                      }

                                      context
                                          .read<AppState>()
                                          .incrementActiveZikir();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom glowing line
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.primary.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension for simple blurring if not using BackdropFilter over content
extension BlurEffect on Container {
  Widget blur({double blurRadius = 20}) {
    return Container(
      width: constraints?.maxWidth,
      height: constraints?.maxHeight,
      decoration: BoxDecoration(
        color: decoration is BoxDecoration
            ? (decoration as BoxDecoration).color
            : null,
        shape: decoration is BoxDecoration
            ? (decoration as BoxDecoration).shape
            : BoxShape.rectangle,
        borderRadius: decoration is BoxDecoration
            ? (decoration as BoxDecoration).borderRadius
            : null,
        boxShadow: [
          BoxShadow(
            color:
                (decoration is BoxDecoration
                    ? (decoration as BoxDecoration).color
                    : Colors.transparent) ??
                Colors.transparent,
            blurRadius: blurRadius,
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }
}
