import 'package:flutter/material.dart';

class AddEventPageRuote extends PageRouteBuilder {
  final Widget page;

  AddEventPageRuote({required this.page})
    : super (
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 200), // Push duration
      reverseTransitionDuration: const Duration(milliseconds: 200), // Pop duration
      barrierDismissible: true,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
    );

}