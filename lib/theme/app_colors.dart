import 'package:flutter/material.dart';

class AppColors {
  // Brand colors (from existing website)
  static const Color primary = Color(0xFF4E73DF);
  static const Color primaryDark = Color(0xFF224ABE);
  static const Color primaryLight = Color(0xFF859DED);
  static const Color success = Color(0xFF1CC88A);
  static const Color info = Color(0xFF36B9CC);
  static const Color warning = Color(0xFFF6C23E);
  static const Color danger = Color(0xFFE74A3B);

  // Neutral colors
  static const Color bg = Color(0xFFF3F4F6);
  static const Color card = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF5A5C69);
  static const Color textDark = Color(0xFF3D3E45);
  static const Color muted = Color(0xFF858796);
  static const Color line = Color(0xFFE3E6F0);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [primaryDark, primary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF1CC88A), Color(0xFF17A673)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient infoGradient = LinearGradient(
    colors: [Color(0xFF36B9CC), Color(0xFF258391)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
