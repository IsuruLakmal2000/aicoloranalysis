import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Elegant Color Palette for Fashion-Conscious Women
  static const Color primaryColor = Color(0xFFF4C2C2); // Soft blush pink
  static const Color secondaryColor = Color(0xFFE6D7F2); // Muted lavender
  static const Color accentColor = Color(0xFFE8A87C); // Warm nude/coral
  static const Color backgroundColor = Color(0xFFFAF9F7); // Creamy white
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure white
  
  // Accent colors for highlights and buttons
  static const Color goldAccent = Color(0xFFD4AF37); // Elegant gold
  static const Color roseGoldAccent = Color(0xFFE8B4B8); // Rose gold
  static const Color coralAccent = Color(0xFFFF7F7F); // Soft coral
  static const Color deepMauve = Color(0xFF8E4B8E); // Deep mauve for CTAs
  static const Color strongMauve = Color(0xFF9C4D9C); // Stronger mauve for better visibility
  
  // Text colors
  static const Color textPrimaryColor = Color(0xFF4A4A4A); // Soft charcoal
  static const Color textSecondaryColor = Color(0xFF8B8B8B); // Medium gray
  static const Color textLightColor = Color(0xFFB8B8B8); // Light gray
  
  // Additional palette
  static const Color softPurple = Color(0xFFF0E6F7); // Very light lavender
  static const Color warmBeige = Color(0xFFF5F0E8); // Warm neutral
  
  // Elegant shadow with subtle warmth
  static final BoxShadow softShadow = BoxShadow(
    color: primaryColor.withOpacity(0.08),
    blurRadius: 12,
    spreadRadius: 0,
    offset: const Offset(0, 6),
  );
  
  // Soft gradient for depth
  static final LinearGradient softGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      backgroundColor,
      backgroundColor.withOpacity(0.8),
    ],
  );
  
  // Elegant Typography with Poppins
  static TextTheme getTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        color: textPrimaryColor,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w300,
        color: textPrimaryColor,
        letterSpacing: -0.25,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24, 
        fontWeight: FontWeight.w400,
        color: textPrimaryColor,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondaryColor,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textLightColor,
        height: 1.3,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: surfaceColor,
        letterSpacing: 0.5,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondaryColor,
        letterSpacing: 0.25,
      ),
    );
  }
  
  // Elegant Theme Data
  static ThemeData getThemeData() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: getTextTheme(),
      
      // AppBar with clean, minimal styling
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textPrimaryColor),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
          letterSpacing: -0.25,
        ),
        toolbarHeight: 60,
      ),
      
      // Elegant button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepMauve,
          foregroundColor: surfaceColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.25,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: deepMauve,
          side: BorderSide(color: deepMauve.withOpacity(0.5), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.25,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: deepMauve,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.25,
          ),
        ),
      ),
      
      // Elegant card theme
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shadowColor: primaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      
      // Modern color scheme
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        onPrimary: surfaceColor,
        onSecondary: textPrimaryColor,
        onTertiary: surfaceColor,
        onSurface: textPrimaryColor,
        onBackground: textPrimaryColor,
        error: const Color(0xFFE57373), // Soft red
        onError: surfaceColor,
        outline: textLightColor,
        surfaceVariant: softPurple,
        onSurfaceVariant: textSecondaryColor,
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: softPurple.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: deepMauve, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.poppins(
          color: textLightColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: textSecondaryColor,
        size: 24,
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: textLightColor.withOpacity(0.3),
        thickness: 0.5,
        space: 1,
      ),
    );
  }
  
  // Helper methods for gradient backgrounds
  static BoxDecoration getGradientDecoration({
    List<Color>? colors,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors ?? [backgroundColor, softPurple.withOpacity(0.3)],
      ),
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      boxShadow: [softShadow],
    );
  }
  
  // Elegant button gradient
  static BoxDecoration getButtonGradient() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          deepMauve,
          deepMauve.withOpacity(0.8),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: deepMauve.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
