// import 'package:flutter/material.dart';

// class AppColors {
//   // Primary Colors - ألوان أساسية عصرية
//   static const Color primary = Color(0xFF6366F1); // Indigo
//   static const Color primaryLight = Color(0xFF818CF8);
//   static const Color primaryDark = Color(0xFF4F46E5);

//   // Secondary Colors
//   static const Color secondary = Color(0xFF10B981); // Emerald
//   static const Color secondaryLight = Color(0xFF34D399);
//   static const Color secondaryDark = Color(0xFF059669);

//   // Accent Colors
//   static const Color accent = Color(0xFFF59E0B); // Amber
//   static const Color accentLight = Color(0xFFFBBF24);

//   // Background Colors
//   static const Color background = Color(0xFFF8FAFC);
//   static const Color surface = Color(0xFFFFFFFF);
//   static const Color surfaceDark = Color(0xFF1E293B);

//   // Text Colors
//   static const Color textPrimary = Color(0xFF0F172A);
//   static const Color textSecondary = Color(0xFF64748B);
//   static const Color textLight = Color(0xFF94A3B8);

//   // Status Colors
//   static const Color success = Color(0xFF10B981);
//   static const Color warning = Color(0xFFF59E0B);
//   static const Color error = Color(0xFFEF4444);
//   static const Color info = Color(0xFF3B82F6);

//   // Chart Colors - ألوان للرسوم البيانية
//   static const List<Color> chartColors = [
//     Color(0xFF6366F1), // Indigo
//     Color(0xFF10B981), // Emerald
//     Color(0xFFF59E0B), // Amber
//     Color(0xFFEC4899), // Pink
//     Color(0xFF8B5CF6), // Violet
//     Color(0xFF06B6D4), // Cyan
//   ];

//   // Gradient Colors - تدرجات حديثة
//   static const LinearGradient primaryGradient = LinearGradient(
//     colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static const LinearGradient successGradient = LinearGradient(
//     colors: [Color(0xFF10B981), Color(0xFF34D399)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static const LinearGradient warningGradient = LinearGradient(
//     colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static const LinearGradient errorGradient = LinearGradient(
//     colors: [Color(0xFFEF4444), Color(0xFFF87171)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   // Shadow Colors
//   static const Color shadowLight = Color(0x0F000000);
//   static const Color shadowMedium = Color(0x1A000000);

//   // Border Colors
//   static const Color border = Color(0xFFE2E8F0);
//   static const Color borderDark = Color(0xFFCBD5E1);

//   // Shimmer Colors (للتحميل)
//   static const Color shimmerBase = Color(0xFFE2E8F0);
//   static const Color shimmerHighlight = Color(0xFFF1F5F9);
// }
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - ألوان أساسية عصرية (محدثة)
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors (محدثة)
  static const Color secondary = Color(0xFF10B981); // Emerald
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF059669);

  // Accent Colors (محدثة وإضافات جديدة)
  static const Color accent = Color(0xFFF59E0B); // Amber
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentNeon = Color(0xFFFF6B35); // Neon Orange للإبراز
  static const Color accentPurple = Color(0xFF8B5CF6); // Purple للأزرار

  // Background Colors (إضافات عصرية)
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color backgroundPastel = Color(
    0xFFF0F9FF,
  ); // Pastel Blue للخلفيات الناعمة
  static const Color backgroundSoft = Color(0xFFF5F5F5); // Soft Gray للـ cards

  // Text Colors (محدثة)
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textAccent = Color(0xFF6366F1); // للنصوص البارزة

  // Status Colors (محدثة وإضافات)
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color successPastel = Color(0xFFD1FAE5); // Pastel Green للنجاح
  static const Color warningPastel = Color(0xFFFEF3C7); // Pastel Yellow للتحذير

  // Chart Colors - ألوان للرسوم البيانية (محدثة)
  static const List<Color> chartColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFEC4899), // Pink
    Color(0xFF8B5CF6), // Violet
    Color(0xFF06B6D4), // Cyan
    Color(0xFFFF6B35), // Neon Orange (جديد)
    Color(0xFF34D399), // Light Emerald (جديد)
  ];

  // Gradient Colors - تدرجات حديثة (إضافات جديدة)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFF87171)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // تدرجات جديدة عصرية
  static const LinearGradient neonGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFEC4899)], // Neon Orange to Pink
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pastelGradient = LinearGradient(
    colors: [Color(0xFFF0F9FF), Color(0xFFF5F5F5)], // Pastel Blue to Soft Gray
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient purpleAccentGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)], // Purple to Indigo
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors (محدثة)
  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowMedium = Color(0x1A000000);
  static const Color shadowNeon = Color(0x1AFF6B35); // Neon Shadow للإبراز

  // Border Colors (محدثة)
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFFCBD5E1);
  static const Color borderAccent = Color(
    0xFF6366F1,
  ); // للحدود البارزة// Shimmer Colors (للتحميل) - محدثة
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF1F5F9);
  static const Color shimmerPastel = Color(0xFFF0F9FF); // Pastel للتحميل الناعم
}
