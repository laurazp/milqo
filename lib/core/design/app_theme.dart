import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'dimens.dart';

/// Tema Material 3 del MVP — apartado 2 (Identidad visual): esquinas
/// redondeadas, tarjetas con espacio de respiro, Poppins en títulos y
/// botones, y verde salvia como único color de acción principal (el coral
/// se reserva para "favoritos").
abstract class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.sageGreen,
      brightness: Brightness.light,
      surface: AppColors.cardSurface,
      primary: AppColors.sageGreen,
      onPrimary: Colors.white,
      secondary: AppColors.favoriteCoral,
    );

    final baseText = GoogleFonts.interTextTheme();
    final headingFont = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: baseText.copyWith(
        headlineLarge: headingFont.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: headingFont.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineSmall: headingFont.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleLarge: headingFont.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: headingFont.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: baseText.bodyLarge?.copyWith(color: AppColors.textPrimary),
        bodyMedium: baseText.bodyMedium?.copyWith(color: AppColors.textPrimary),
        bodySmall: baseText.bodySmall?.copyWith(color: AppColors.textSecondary),
        labelLarge: headingFont.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.cardSurface,
        indicatorColor: AppColors.sageGreen.withValues(alpha: 0.18),
        elevation: 0,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.sageGreen : AppColors.textSecondary,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.poppins(
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.sageGreen : AppColors.textSecondary,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.cardCornerRadius),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardSurface,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimens.semiLargeMargin,
          vertical: Dimens.mediumMargin,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
          borderSide: const BorderSide(color: AppColors.sageGreen, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sageGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.sageGreen.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(vertical: Dimens.semiLargeMargin),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.buttonCornerRadius),
          ),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkGreen,
          side: const BorderSide(color: AppColors.sageGreen),
          padding: const EdgeInsets.symmetric(vertical: Dimens.semiLargeMargin),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.buttonCornerRadius),
          ),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkGreen,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cardSurface,
        selectedColor: AppColors.sageGreen.withValues(alpha: 0.18),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
