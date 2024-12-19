import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFFF8C00);
  static const secondary = Color(0xFFFFECDD);
  static const background = Color(0xFFF5F5F5);
  static const cardBackground = Colors.white;
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const accent = Color(0xFFFF6B00);


  static final primaryGradient = LinearGradient(
    colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,


  );

  static var divider;

  static var iconColor;

  static var dividerColor;

  static var textTertiary;

  static var destructive;
}