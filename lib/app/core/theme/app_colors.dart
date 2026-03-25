import 'package:flutter/material.dart';

/// ═══════════════════════════════════════════════════════════════
/// AppColors — Smart LMS Teacher App
/// Palette: Ocean Teal Modern
/// Primary:   Teal       #0D9488  — ثقة + نمو + عصرية
/// Secondary: Blue       #3B82F6  — وضوح + تقنية
/// Accent:    Orange     #F97316  — طاقة + تنبيه
/// BG:        Teal-tinted off-white — متناسق مع Primary
/// ═══════════════════════════════════════════════════════════════
class AppColors {
  AppColors._();

  // ─── Primary — Teal ───────────────────────────────────────────
  static const Color primary = Color(0xFF0D9488);
  static const Color primaryLight = Color(0xFF14B8A6);
  static const Color primaryDark = Color(0xFF0F766E);

  static const Color primarySurface = Color(
    0xFFE6FAF8,
  ); // teal-tinted خفيف جداً
  static const Color primaryBorder = Color(0xFFB2E8E4);

  // ─── Secondary — Blue ─────────────────────────────────────────
  static const Color secondary = Color(0xFF3B82F6);
  static const Color secondaryLight = Color(0xFF60A5FA);
  static const Color secondaryDark = Color(0xFF2563EB);

  static const Color secondarySurface = Color(0xFFEFF6FF);
  static const Color secondaryBorder = Color(0xFFBFDBFE);

  // ─── Accent — Orange ──────────────────────────────────────────
  static const Color accent = Color(0xFFF97316);
  static const Color accentDark = Color(0xFFEA580C);
  static const Color accentSurface = Color(0xFFFFF4ED);
  static const Color accentBorder = Color(0xFFFED7AA);

  // ─── Card Colors — منبثقة من الـ palette ──────────────────────
  /// بطاقة الفصول — Teal (Primary)
  static const Color cardTeal = Color(0xFF0D9488);
  static const Color cardTealDark = Color(0xFF0F766E);

  /// بطاقة الطلاب — Blue (Secondary)
  static const Color cardBlue = Color(0xFF3B82F6);
  static const Color cardBlueDark = Color(0xFF2563EB);

  /// بطاقة الاختبارات — Violet (مكمّل للـ Teal)
  static const Color cardViolet = Color(0xFF8B5CF6);
  static const Color cardVioletDark = Color(0xFF7C3AED);

  /// بطاقة المتوسط — Orange (Accent)
  static const Color cardOrange = Color(0xFFF97316);
  static const Color cardOrangeDark = Color(0xFFEA580C);

  // ─── Semantic — Status Colors ─────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFF22C55E);
  static const Color successSurface = Color(0xFFDCFCE7);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSurface = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color errorSurface = Color(0xFFFEE2E2);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoSurface = Color(0xFFEFF6FF);

  // ─── Backgrounds ──────────────────────────────────────────────
  /// خلفية متناسقة مع Teal — off-white مع مسحة خضراء باردة خفيفة
  static const Color background = Color(0xFFF0FAFA);

  /// سطح البطاقات والـ modals
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);

  // ─── Text ─────────────────────────────────────────────────────
  static const Color textPrimary = Color(
    0xFF0D2B28,
  ); // أخضر داكن جداً — ناعم على العين
  static const Color textSecondary = Color(0xFF3D6B67);
  static const Color textTertiary = Color(0xFF7AACA8);
  static const Color textDisabled = Color(0xFFB2D4D1);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // ─── Border & Divider ─────────────────────────────────────────
  static const Color border = Color(0xFFD1EAE8);
  static const Color borderDark = Color(0xFFADD5D1);
  static const Color divider = Color(0xFFE8F5F4);

  // ─── Shadows ──────────────────────────────────────────────────
  static const Color shadowSoft = Color(0x0C0D9488); // teal shadow خفيف
  static const Color shadowMedium = Color(0x1A000000);
  static const Color shadowCard = Color(0x100D2B28);

  // ─── Chart Colors ─────────────────────────────────────────────
  static const List<Color> chartColors = [
    Color(0xFF0D9488), // Teal Primary
    Color(0xFF3B82F6), // Blue
    Color(0xFFF97316), // Orange
    Color(0xFF8B5CF6), // Violet
    Color(0xFF16A34A), // Green
    Color(0xFFF59E0B), // Amber
    Color(0xFFDC2626), // Red
    Color(0xFF06B6D4), // Cyan
  ];

  // ─── Gradients ────────────────────────────────────────────────
  /// Header gradient رئيسي
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// تدرج ناعم أفتح — للبطاقات والـ banners
  static const LinearGradient primarySoftGradient = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient violetGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF16A34A), Color(0xFF15803D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Shimmer ──────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFFD9F0EE);
  static const Color shimmerHighlight = Color(0xFFEEF9F8);
  static const Color shimmerPastel = Color(0xFFE6FAF8);

  // ─── Backward-Compatible Aliases ─────────────────────────────
  // جميع الأسماء القديمة محتفظ بها — لا يتكسر أي ملف في المشروع

  /// @deprecated → [accentDark] أو [accentSurface]
  static const Color accentLight = Color(0xFFFDBA74);

  /// @deprecated → [secondary]
  static const Color accentPurple = secondary;

  /// @deprecated → dark surface
  static const Color surfaceDark = Color(0xFF0D2B28);

  /// @deprecated → [background]
  static const Color backgroundPastel = background;

  /// @deprecated → [background]
  static const Color backgroundSoft = Color(0xFFEAF7F6);

  /// @deprecated → [textTertiary]
  static const Color textLight = textTertiary;

  /// @deprecated → [primary]
  static const Color textAccent = primary;

  /// @deprecated → [successSurface]
  static const Color successPastel = successSurface;

  /// @deprecated → [warningSurface]
  static const Color warningPastel = warningSurface;

  /// @deprecated → [shadowCard]
  static const Color shadowLight = shadowCard;

  /// @deprecated → [primaryBorder]
  static const Color borderAccent = primaryBorder;

  /// @deprecated → [accent] fallback
  static const Color accentNeon = Color(0xFFF97316);

  /// @deprecated → accent shadow
  static const Color shadowNeon = Color(0x1AF97316);

  // ─── Smart Class Color Mapper ──────────────────────────────────
  /// يحوّل أي لون قادم من DB لأقرب لون متناسق من الـ Palette
  /// بدل الاعتماد على ألوان عشوائية قديمة مخزنة في قاعدة البيانات
  ///
  /// الاستخدام:
  /// ```dart
  /// // قبل:
  /// final color = Color(int.parse(classItem.color));
  /// // بعد:
  /// final color = AppColors.getClassColor(classItem.color);
  /// ```
  static const List<Color> _classPalette = [
    Color(0xFF0D9488), // Teal    — Primary
    Color(0xFF3B82F6), // Blue    — Secondary
    Color(0xFF7C3AED), // Violet  — للتمييز
    Color(0xFFF97316), // Orange  — Accent
    Color(0xFF16A34A), // Green   — Success
    Color(0xFF0891B2), // Cyan    — Info variant
  ];

  static Color getClassColor(String hexColor) {
    try {
      final dbColor = Color(int.parse(hexColor));
      return _nearestPaletteColor(dbColor);
    } catch (_) {
      return primary; // fallback آمن
    }
  }

  /// يجد أقرب لون في الـ palette باستخدام مسافة HSL
  static Color _nearestPaletteColor(Color input) {
    final inputHsl = HSLColor.fromColor(input);

    Color nearest = _classPalette.first;
    double minDistance = double.infinity;

    for (final candidate in _classPalette) {
      final candidateHsl = HSLColor.fromColor(candidate);

      // حساب المسافة بناءً على Hue فقط (الأهم بصرياً)
      double hueDiff = (inputHsl.hue - candidateHsl.hue).abs();
      if (hueDiff > 180) hueDiff = 360 - hueDiff; // circular distance

      if (hueDiff < minDistance) {
        minDistance = hueDiff;
        nearest = candidate;
      }
    }

    return nearest;
  }

  /// للحصول على gradient متناسق من لون الفصل
  static LinearGradient getClassGradient(String hexColor) {
    final base = getClassColor(hexColor);
    // تعتيم طفيف للـ gradient
    final dark = Color.fromARGB(
      base.alpha,
      (base.red * 0.82).round(),
      (base.green * 0.82).round(),
      (base.blue * 0.82).round(),
    );
    return LinearGradient(
      colors: [base, dark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
