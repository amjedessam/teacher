import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageTransitions {
  // 1. Fade Transition
  static Transition fade = Transition.fade;

  // 2. Slide from Right
  static Transition slideRight = Transition.rightToLeft;

  // 3. Slide from Left
  static Transition slideLeft = Transition.leftToRight;

  // 4. Slide from Bottom
  static Transition slideBottom = Transition.downToUp;

  // 5. Zoom Transition
  static Transition zoom = Transition.zoom;

  // 6. Custom Slide & Fade
  static GetPageRoute slideAndFade(Widget page) {
    return GetPageRoute(
      page: () => page,
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // 7. Custom Scale & Fade
  static Widget scaleAndFade({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: child,
      ),
    );
  }

  // 8. Shared Axis Transition (Material Design)
  static Widget sharedAxis({
    required Widget child,
    required Animation<double> animation,
    SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
  }) {
    final offsetTween = type == SharedAxisTransitionType.horizontal
        ? Tween<Offset>(begin: const Offset(0.3, 0.0), end: Offset.zero)
        : Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: offsetTween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
        ),
        child: child,
      ),
    );
  }

  // 9. Custom Rotation Transition
  static Widget rotation({
    required Widget child,
    required Animation<double> animation,
  }) {
    return RotationTransition(
      turns: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.elasticOut)),
      child: child,
    );
  }
}

enum SharedAxisTransitionType { horizontal, vertical }

// Custom Page Route Builder
class CustomPageRoute extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  CustomPageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 400),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           // Slide from right with fade
           const begin = Offset(1.0, 0.0);
           const end = Offset.zero;
           const curve = Curves.easeInOutCubic;

           var tween = Tween(
             begin: begin,
             end: end,
           ).chain(CurveTween(curve: curve));

           return FadeTransition(
             opacity: animation,
             child: SlideTransition(
               position: animation.drive(tween),
               child: child,
             ),
           );
         },
       );
}
