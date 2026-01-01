import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ProgressBar extends StatelessWidget {
  final int current;
  final int target;

  const ProgressBar({super.key, required this.current, required this.target});

  @override
  Widget build(BuildContext context) {
    final double percentage = (current / target).clamp(0.0, 1.0);
    final int percentDisplay = (percentage * 100).toInt();

    return Column(
      children: [
        // Labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("TARGET GOAL", style: AppTextStyles.labelSmall(context)),
              RichText(
                text: TextSpan(
                  text: "$current ",
                  style: AppTextStyles.labelMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "/ $target",
                      style: const TextStyle(
                        color: AppColors.textGray,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Bar
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 2), // shadow-inner approx
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    width: constraints.maxWidth * percentage,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Bottom Labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Keep going, you're doing great.",
                style: AppTextStyles.labelMedium(
                  context,
                ).copyWith(fontSize: 12),
              ),
              Text(
                "$percentDisplay%",
                style: AppTextStyles.labelMedium(
                  context,
                ).copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
