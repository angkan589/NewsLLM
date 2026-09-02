import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  Color get pageBackground => Theme.of(this).scaffoldBackgroundColor;

  Color get surfaceColor => colors.surface;

  Color get elevatedSurfaceColor =>
      isDarkTheme ? const Color(0xFF182438) : const Color(0xFFFFFFFF);

  Color get primaryTextColor => colors.onSurface;

  Color get secondaryTextColor => colors.onSurfaceVariant;

  Color get borderColor => colors.outlineVariant;

  Color get mutedBackgroundColor =>
      isDarkTheme ? const Color(0xFF1B293D) : const Color(0xFFE8EDF5);

  Color get blueTintColor =>
      isDarkTheme ? const Color(0xFF172A46) : const Color(0xFFEFF6FF);

  Color get yellowTintColor =>
      isDarkTheme ? const Color(0xFF352A13) : const Color(0xFFFFFBEB);

  Color get greenTintColor =>
      isDarkTheme ? const Color(0xFF12352D) : const Color(0xFFECFDF5);

  Color get redTintColor =>
      isDarkTheme ? const Color(0xFF3B1A1F) : const Color(0xFFFEF2F2);
}
