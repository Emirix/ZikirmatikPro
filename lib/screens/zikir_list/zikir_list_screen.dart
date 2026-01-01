import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/zikir_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ZikirListScreen extends StatelessWidget {
  const ZikirListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final zikirs = appState.zikirs;
    final totalCount = zikirs.fold(0, (sum, item) => sum + item.currentCount);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddZikirDialog(context),
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).scaffoldBackgroundColor,
          size: 32,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Zikirler",
                        style: AppTextStyles.titleLarge(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Zikirlerim",
                        style: AppTextStyles.headerTitle(context),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Toplam",
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "$totalCount",
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  100,
                ), // Bottom padding for FAB
                itemCount: zikirs.length,
                itemBuilder: (context, index) {
                  final zikir = zikirs[index];
                  final isActive = appState.activeZikir?.id == zikir.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _ZikirCard(
                      zikir: zikir,
                      isActive: isActive,
                      onTap: () {
                        context.read<AppState>().setActiveZikir(zikir.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "'${zikir.title}' seçildi.",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            duration: const Duration(milliseconds: 500),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                          ),
                        );
                      },
                      onLongPress: () async {
                        // Show delete confirmation dialog
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            title: Text(
                              "Zikri Sil",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            content: Text(
                              "'${zikir.title}' zikrini silmek istediğinizden emin misiniz?",
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text("İptal"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(
                                  "Sil",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          context.read<AppState>().deleteZikir(zikir.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "'${zikir.title}' silindi.",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              duration: const Duration(milliseconds: 500),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surface,
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddZikirDialog(BuildContext context) {
    // Basic dialog implementation
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final targetController = TextEditingController(text: "100");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Yeni Zikir Ekle",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Başlık",
                labelStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: "Açıklama / Arapça",
                labelStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            TextField(
              controller: targetController,
              decoration: const InputDecoration(
                labelText: "Hedef",
                labelStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final target = int.tryParse(targetController.text) ?? 100;
                context.read<AppState>().addZikir(
                  titleController.text,
                  descController.text,
                  target,
                );
                Navigator.pop(ctx);
              }
            },
            child: Text(
              "Ekle",
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZikirCard extends StatelessWidget {
  final ZikirModel zikir;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _ZikirCard({
    required this.zikir,
    required this.isActive,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (zikir.currentCount / zikir.targetCount).clamp(0.0, 1.0);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.surface.withOpacity(0.8)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: isActive
              ? Border.all(color: AppColors.primary.withOpacity(0.5))
              : Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.05),
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withOpacity(0.2)
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isActive ? Icons.play_arrow : Icons.radio_button_unchecked,
                color: isActive ? AppColors.primary : Colors.grey,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        zikir.title,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (zikir.currentCount >= zikir.targetCount)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "Tamamlandı",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    zikir.description,
                    style: const TextStyle(
                      color: AppColors.textGray,
                      fontSize: 14,
                      fontFamily:
                          'Manrope', // Should use Arabic font if possible, but Manrope is default
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Progress Bar
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      Container(
                        height: 6,
                        width:
                            MediaQuery.of(context).size.width *
                            0.5 *
                            progress, // Approx width
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.5),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Count
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${zikir.currentCount}",
                  style: TextStyle(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "/${zikir.targetCount}",
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
