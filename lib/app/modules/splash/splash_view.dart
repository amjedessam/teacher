import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF0D6EBD), Color(0xFF0A9396)],
          ),
        ),
        child: Stack(
          children: [
            // ── دوائر زخرفية خلفية ─────────────────────────
            Positioned(
              top: -80,
              left: -80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              top: 60,
              right: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -60,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),

            // ── نقاط زخرفية صغيرة ──────────────────────────
            Positioned(
              top: size.height * 0.18,
              left: size.width * 0.12,
              child: _buildDot(6, 0.3),
            ),
            Positioned(
              top: size.height * 0.25,
              right: size.width * 0.1,
              child: _buildDot(4, 0.2),
            ),
            Positioned(
              bottom: size.height * 0.22,
              left: size.width * 0.15,
              child: _buildDot(5, 0.25),
            ),
            Positioned(
              bottom: size.height * 0.3,
              right: size.width * 0.12,
              child: _buildDot(7, 0.2),
            ),

            // ── المحتوى المركزي ─────────────────────────────
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── الشعار ─────────────────────────────────
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // هالة خارجية
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      // هالة وسطى
                      Container(
                        width: 122,
                        height: 122,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                      // الدائرة البيضاء مع الشعار
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Image.asset(
                              'assets/images/roshd.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  // ── اسم المنصة ─────────────────────────────
                  const Text(
                    'منصة رُشد',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── شريط بوابة المعلم ──────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'بوابة المعلم',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 72),

                  // ── مؤشر التحميل ───────────────────────────
                  Column(
                    children: [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 2.5,
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'جاري التحميل...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── footer ─────────────────────────────────────
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Text(
                'منصة رُشد التعليمية الذكية© 2026',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.4),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}
