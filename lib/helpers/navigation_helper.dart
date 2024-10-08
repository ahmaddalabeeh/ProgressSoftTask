import 'package:flutter/material.dart';

class NavigationHelper {
  static Future<void> navigateToAsync(BuildContext context, Widget page) {
    return Navigator.of(context).push(_createRoute(page));
  }

  static void navigateToReplacement(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(_createRoute(page));
  }

  static void navigatePushAndRemoveUntil(BuildContext context, Widget page) {
    Navigator.of(context)
        .pushAndRemoveUntil(_createRoute(page), (route) => false);
  }

  static Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
