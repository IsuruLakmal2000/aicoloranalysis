import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette - Warm, Elegant & Feminine
  static const Color primaryColor = Color(0xFFDA627D); // Warm rose - interactive elements
  static const Color secondaryColor = Color(0xFFFFA5AB); // Light coral pink - secondary elements
  static const Color accentColor = Color(0xFFDA627D); // Warm rose - accents
  static const Color backgroundColor = Color(0xFFF9DBBD); // Soft cream - primary background
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure white - cards/surfaces
  
  // Button and interaction colors
  static const Color goldAccent = Color(0xFFDA627D); // Warm rose for highlights
  static const Color roseGoldAccent = Color(0xFFFFA5AB); // Light coral pink
  static const Color coralAccent = Color(0xFFFFA5AB); // Light coral pink
  static const Color deepMauve = Color(0xFFA53860); // Deep magenta - primary buttons
  static const Color strongMauve = Color(0xFFA53860); // Deep magenta - strong actions
  
  // Text colors
  static const Color textPrimaryColor = Color(0xFF450920); // Dark plum - primary text
  static const Color textSecondaryColor = Color(0xFFA53860); // Deep magenta - secondary text
  static const Color textLightColor = Color(0xFFDA627D); // Warm rose - disabled/light text
  
  // Additional palette
  static const Color softPurple = Color(0xFFFFA5AB); // Light coral pink - backgrounds
  static const Color warmBeige = Color(0xFFF9DBBD); // Soft cream - neutral areas
  
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
        backgroundColor: Color(0xFFF9DBBD), // Soft cream background
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF450920)), // Dark plum icons
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Color(0xFF450920), // Dark plum title
          letterSpacing: -0.25,
        ),
        toolbarHeight: 60,
      ),
      
      // Elegant button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA53860), // Deep magenta default
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
        ).copyWith(
          // Hover and pressed states
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.hovered)) {
              return Color(0xFFDA627D); // Warm rose on hover
            }
            if (states.contains(MaterialState.pressed)) {
              return Color(0xFF450920); // Dark plum when pressed
            }
            return Color(0xFFA53860); // Deep magenta default
          }),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFFA53860), // Deep magenta text
          side: BorderSide(color: Color(0xFFA53860).withOpacity(0.5), width: 1.5),
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
          foregroundColor: Color(0xFFA53860), // Deep magenta text
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
        primary: Color(0xFFA53860), // Deep magenta - primary actions
        secondary: Color(0xFFFFA5AB), // Light coral pink - secondary elements
        tertiary: Color(0xFFDA627D), // Warm rose - tertiary elements
        surface: surfaceColor,
        background: Color(0xFFF9DBBD), // Soft cream background
        onPrimary: surfaceColor,
        onSecondary: Color(0xFF450920), // Dark plum on secondary
        onTertiary: surfaceColor,
        onSurface: Color(0xFF450920), // Dark plum on surface
        onBackground: Color(0xFF450920), // Dark plum on background
        error: const Color(0xFFE57373), // Soft red
        onError: surfaceColor,
        outline: Color(0xFFDA627D), // Warm rose outlines
        surfaceVariant: Color(0xFFFFA5AB).withOpacity(0.2), // Light coral tint
        onSurfaceVariant: Color(0xFFA53860), // Deep magenta on surface variant
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFFFA5AB).withOpacity(0.15), // Light coral pink fill
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFFDA627D).withOpacity(0.4)), // Warm rose border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFFA53860), width: 2), // Deep magenta focus
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.poppins(
          color: Color(0xFFDA627D), // Warm rose for hints
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: Color(0xFFA53860), // Deep magenta for icons
        size: 24,
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: Color(0xFFDA627D).withOpacity(0.3), // Warm rose dividers
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
