import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo',

      // ─── Color Scheme ─────────────────────────────────────────
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        primaryContainer: AppColors.primarySurface,
        onPrimaryContainer: AppColors.primaryDark,

        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnPrimary,
        secondaryContainer: AppColors.secondarySurface,
        onSecondaryContainer: AppColors.secondaryDark,

        tertiary: AppColors.accent,
        onTertiary: AppColors.textOnPrimary,
        tertiaryContainer: AppColors.accentSurface,
        onTertiaryContainer: AppColors.accentDark,

        error: AppColors.error,
        onError: AppColors.textOnPrimary,
        errorContainer: AppColors.errorSurface,

        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.background,

        outline: AppColors.border,
        outlineVariant: AppColors.divider,
      ),

      // ─── Scaffold ─────────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.background,

      // ─── AppBar ───────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: AppTextStyles.h3,
        iconTheme: IconThemeData(color: AppColors.textPrimary, size: 22),
        actionsIconTheme: IconThemeData(color: AppColors.textPrimary, size: 22),
      ),

      // ─── Card ─────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shadowColor: AppColors.shadowCard,
      ),

      // ─── Elevated Button ──────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textDisabled,
          textStyle: AppTextStyles.button,
          shadowColor: Colors.transparent,
        ),
      ),

      // ─── Outlined Button ──────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonOutlined,
        ),
      ),

      // ─── Text Button ──────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      ),

      // ─── FAB ──────────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // ─── Input Decoration ─────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        labelStyle: AppTextStyles.label,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        errorStyle: AppTextStyles.captionMedium.copyWith(
          color: AppColors.error,
        ),
        prefixIconColor: AppColors.textTertiary,
        suffixIconColor: AppColors.textTertiary,
      ),

      // ─── Chip ─────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primarySurface,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.divider,
        deleteIconColor: AppColors.primary,
        labelStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
        secondaryLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textOnPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.primaryBorder),
        ),
        side: const BorderSide(color: AppColors.primaryBorder),
        elevation: 0,
        pressElevation: 0,
      ),

      // ─── Divider ──────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ─── Icon ─────────────────────────────────────────────────
      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 22),

      // ─── Bottom Navigation Bar ────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        enableFeedback: true,
        selectedLabelStyle: AppTextStyles.navLabel.copyWith(
          color: AppColors.primary,
        ),
        unselectedLabelStyle: AppTextStyles.navLabel.copyWith(
          color: AppColors.textTertiary,
        ),
      ),

      // ─── NavigationBar (Material3) ────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primarySurface,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 22);
          }
          return const IconThemeData(color: AppColors.textTertiary, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.navLabel.copyWith(color: AppColors.primary);
          }
          return AppTextStyles.navLabel.copyWith(color: AppColors.textTertiary);
        }),
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),

      // ─── Dialog ───────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        shadowColor: AppColors.shadowMedium,
        backgroundColor: AppColors.surface,
        titleTextStyle: AppTextStyles.h3,
        contentTextStyle: AppTextStyles.bodyMedium,
        surfaceTintColor: Colors.transparent,
      ),

      // ─── Bottom Sheet ─────────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        elevation: 8,
        shadowColor: AppColors.shadowMedium,
        dragHandleColor: AppColors.border,
      ),

      // ─── Snackbar ─────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
        actionTextColor: AppColors.primaryLight,
        elevation: 4,
      ),

      // ─── List Tile ────────────────────────────────────────────
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        subtitleTextStyle: AppTextStyles.bodySmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),

      // ─── Progress Indicator ───────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primarySurface,
        circularTrackColor: AppColors.primarySurface,
        linearMinHeight: 6,
      ),

      // ─── Switch ───────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected))
            return AppColors.textOnPrimary;
          return AppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.border;
        }),
      ),

      // ─── Tab Bar ──────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiary,
        labelStyle: AppTextStyles.labelBold,
        unselectedLabelStyle: AppTextStyles.label,
        dividerColor: AppColors.border,
        overlayColor: WidgetStateProperty.all(AppColors.primarySurface),
      ),

      // ─── Text Theme ───────────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.h1,
        headlineMedium: AppTextStyles.h2,
        headlineSmall: AppTextStyles.h3,
        titleLarge: AppTextStyles.h3,
        titleMedium: AppTextStyles.h4,
        titleSmall: AppTextStyles.labelBold,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.label,
        labelMedium: AppTextStyles.labelSmall,
        labelSmall: AppTextStyles.caption,
      ),
    );
  }
}
