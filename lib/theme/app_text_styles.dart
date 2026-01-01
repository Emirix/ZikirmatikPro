import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Using Manrope as requested
  static TextStyle get displayHuge => GoogleFonts.manrope(
    fontSize: 96, // ~8rem
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: AppColors.textWhite,
    fontFeatures: [const FontFeature.tabularFigures()],
  );

  static TextStyle get titleLarge => GoogleFonts.manrope(
    fontSize: 36, // ~text-4xl
    fontWeight: FontWeight.w900,
    color: AppColors.textWhite,
    letterSpacing: -1.0,
  );

  static TextStyle get labelMedium => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textGray,
  );

  static TextStyle get labelSmall => GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textGray,
    letterSpacing: 1.0, // wider tracking
  );

  static TextStyle get pillText => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textGray,
  );

  static TextStyle get headerTitle => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0, // tracking-widest
    color: AppColors.primary.withOpacity(0.8),
  );
}
