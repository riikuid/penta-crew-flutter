import 'package:flutter/material.dart';

/// Brand palette. Everything else derives from `ColorScheme.fromSeed`, so
/// changing the seed re-themes the whole app.
abstract final class AppColors {
  static const Color seed = Color(0xFF1E6FD9);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color danger = Color(0xFFC62828);
}
