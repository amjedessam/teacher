import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ═══════════════════════════════════════════════════════════════
/// AppTextStyles — Smart LMS Teacher App
/// Font: Cairo (عربي احترافي مناسب للتطبيقات التعليمية)
/// ملاحظة: جميع أسماء المتغيرات الأصلية محتفظ بها للتوافق
/// ═══════════════════════════════════════════════════════════════
class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Cairo';

  // ─── Display ──────────────────────────────────────────────────
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
    letterSpacing: -0.3,
  );

  // ─── Headings ─────────────────────────────────────────────────
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ─── Body ─────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ─── Caption ──────────────────────────────────────────────────
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  static const TextStyle captionMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// محتفظ بالاسم الأصلي للتوافق مع الكود الموجود
  static const TextStyle captionBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ─── Labels ───────────────────────────────────────────────────
  static const TextStyle label = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle labelBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ─── Buttons ──────────────────────────────────────────────────
  /// محتفظ بالاسم والسلوك الأصلي — أبيض للأزرار الملونة
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.2,
  );

  /// محتفظ بالاسم الأصلي
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
  );

  /// جديد — للأزرار المعكوسة (outlined)
  static const TextStyle buttonOutlined = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.2,
  );

  // ─── Stats & Numbers ──────────────────────────────────────────
  /// محتفظ بالاسم الأصلي + نفس اللون الأصلي (textPrimary داكن)
  /// للاستخدام على الخلفيات الفاتحة — لا تغيير في السلوك
  static const TextStyle statNumber = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// محتفظ بالاسم الأصلي
  static const TextStyle statLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  // ─── Stats إضافية (جديدة — لا تكسر شيئاً) ───────────────────
  static const TextStyle statNumberLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  /// للأرقام على خلفيات داكنة (Header gradient)
  static const TextStyle statNumberOnDark = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle statLabelOnDark = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: 1.3,
  );

  // ─── Score Colors (جديدة) ─────────────────────────────────────
  static const TextStyle scoreHigh = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.success,
    height: 1.2,
  );

  static const TextStyle scoreMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
    height: 1.2,
  );

  static const TextStyle scoreLow = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.error,
    height: 1.2,
  );

  // ─── Navigation (جديد) ───────────────────────────────────────
  static const TextStyle navLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
}
