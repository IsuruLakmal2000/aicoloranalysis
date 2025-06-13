import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  bool get isLight => computeLuminance() > 0.5;
  
  bool get isDark => !isLight;
  
  Color get contrastText => isLight ? Colors.black : Colors.white;
  
  Color withBrightness(double factor) {
    assert(factor >= -1.0 && factor <= 1.0);
    
    if (factor == 0) return this;
    
    // For positive factor, lighten the color
    if (factor > 0) {
      return Color.fromARGB(
        alpha,
        _lighten(red, factor),
        _lighten(green, factor),
        _lighten(blue, factor),
      );
    } 
    // For negative factor, darken the color
    else {
      final darkFactor = factor.abs();
      return Color.fromARGB(
        alpha,
        _darken(red, darkFactor),
        _darken(green, darkFactor),
        _darken(blue, darkFactor),
      );
    }
  }
  
  int _lighten(int value, double factor) {
    return (value + ((255 - value) * factor)).round().clamp(0, 255);
  }
  
  int _darken(int value, double factor) {
    return (value * (1 - factor)).round().clamp(0, 255);
  }
}

class ColorUtils {
  /// Convert hex color string to Flutter Color
  static Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }
  
  /// Convert Flutter Color to hex string
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
  
  /// Check if a color is light or dark
  static bool isLightColor(Color color) {
    return color.computeLuminance() > 0.5;
  }
  
  /// Get a contrasting text color (black or white) based on background
  static Color getContrastingTextColor(Color backgroundColor) {
    return isLightColor(backgroundColor) ? Colors.black : Colors.white;
  }
}
