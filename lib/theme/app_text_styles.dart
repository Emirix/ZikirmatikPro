import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Using Manrope as requested
  static TextStyle displayHuge(BuildContext context) => GoogleFonts.manrope(
    fontSize: 96,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: Theme.of(context).textTheme.displayLarge?.color ?? Colors.white,
    fontFeatures: [const FontFeature.tabularFigures()],
  );

  static TextStyle titleLarge(BuildContext context) => GoogleFonts.manrope(
    fontSize: 36,
    fontWeight: FontWeight.w900,
    color: Theme.of(context).textTheme.displayLarge?.color ?? Colors.white,
    letterSpacing: -1.0,
  );

  static TextStyle labelMedium(BuildContext context) => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textGray,
  );

  static TextStyle labelSmall(BuildContext context) => GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textGray,
    letterSpacing: 1.0,
  );

  static TextStyle pillText(BuildContext context) => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textGray,
  );

  static TextStyle headerTitle(BuildContext context) => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
    color: AppColors.primary.withOpacity(0.8),
  );
}
