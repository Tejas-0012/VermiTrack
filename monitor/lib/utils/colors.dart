import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Green for agriculture/compost theme) - Enhanced with gradient variations
  static const Color primary = Color(0xFF2E7D32); // Green 800
  static const Color primaryDark = Color(0xFF1B5E20); // Green 900
  static const Color primaryLight = Color(0xFF81C784); // Green 300

  // New vibrant gradient colors for modern design
  static const Color gradientStart = Color(0xFF43A047); // Vibrant Green
  static const Color gradientEnd = Color(0xFF1B5E20); // Deep Green
  static const Color gradientAccent = Color(0xFF66BB6A); // Light Green accent

  // Neon/Glow colors for shadow effects
  static const Color glowGreen = Color(0xFF4CAF50);
  static const Color glowLightGreen = Color(0xFF81C784);
  static const Color glowNeon = Color(0xFF69F0AE);

  // Secondary Colors (Blue for water/control theme)
  static const Color secondary = Color(0xFF0288D1); // Blue 700
  static const Color secondaryDark = Color(0xFF01579B); // Blue 900
  static const Color secondaryLight = Color(0xFF4FC3F7); // Light Blue

  // Status Colors - Enhanced with gradients
  static const Color success = Color(0xFF4CAF50); // Green 500
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  static const Color warning = Color(0xFFFF9800); // Orange 500
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  static const Color danger = Color(0xFFF44336); // Red 500
  static const Color dangerLight = Color(0xFFEF9A9A);
  static const Color dangerDark = Color(0xFFD32F2F);

  static const Color info = Color(0xFF2196F3); // Blue 500
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // Neutral Colors - Updated for dark/light mode compatibility
  static const Color background = Color(0xFFF5F5F5); // Grey 100
  static const Color backgroundDark = Color(0xFF121212); // Dark background
  static const Color surface = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color border = Color(0xFFE0E0E0); // Grey 300
  static const Color borderDark = Color(0xFF424242); // Dark border

  // Text Colors
  static const Color textPrimary = Color(0xFF212121); // Grey 900
  static const Color textSecondary = Color(0xFF757575); // Grey 600
  static const Color textDisabled = Color(0xFF9E9E9E); // Grey 500
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // White
  static const Color textSecondaryDark = Color(0xFFB0B0B0); // Light Grey

  // Additional Colors for Charts - Enhanced with gradients
  static const Color chartGreen = Color(0xFF66BB6A); // Green 400
  static const Color chartBlue = Color(0xFF42A5F5); // Blue 400
  static const Color chartYellow = Color(0xFFFFEE58); // Yellow 400
  static const Color chartPurple = Color(0xFFAB47BC); // Purple 400
  static const Color chartOrange = Color(0xFFFFA726); // Orange 400
  static const Color chartTeal = Color(0xFF26A69A); // Teal 400

  // Shadow and Glow Effects Colors
  static const Color shadowLight = Color(
    0x1A000000,
  ); // Light shadow (10% opacity)
  static const Color shadowMedium = Color(
    0x33000000,
  ); // Medium shadow (20% opacity)
  static const Color shadowDark = Color(
    0x4D000000,
  ); // Dark shadow (30% opacity)
  static const Color glowEffect = Color(0x3366BB6A); // Green glow effect

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF43A047), // Vibrant Green
      Color(0xFF2E7D32), // Green 800
      Color(0xFF1B5E20), // Deep Green
    ],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4FC3F7), // Light Blue
      Color(0xFF0288D1), // Blue 700
      Color(0xFF01579B), // Deep Blue
    ],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF81C784), // Light Green
      Color(0xFF4CAF50), // Green
      Color(0xFF388E3C), // Dark Green
    ],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFB74D), // Light Orange
      Color(0xFFFF9800), // Orange
      Color(0xFFF57C00), // Dark Orange
    ],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEF9A9A), // Light Red
      Color(0xFFF44336), // Red
      Color(0xFFD32F2F), // Dark Red
    ],
  );

  static const LinearGradient infoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF64B5F6), // Light Blue
      Color(0xFF2196F3), // Blue
      Color(0xFF1976D2), // Dark Blue
    ],
  );

  // Card background gradients for glassmorphism effect
  static LinearGradient cardGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.9)],
  );

  static LinearGradient cardGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2C2C2C).withOpacity(0.95),
      Color(0xFF1E1E1E).withOpacity(0.9),
    ],
  );

  // Neon glow gradient for special elements
  static const LinearGradient neonGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF69F0AE), // Neon Green
      Color(0xFF00E676), // Bright Green
      Color(0xFF00C853), // Deep Neon Green
    ],
  );

  // Metallic shine effect
  static const LinearGradient metallicShine = LinearGradient(
    begin: Alignment(-1.0, -1.0),
    end: Alignment(1.0, 1.0),
    colors: [
      Color(0xFFFFFFFF), // White shine
      Color(0x00FFFFFF), // Transparent
      Color(0xFFFFFFFF), // White shine
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Helper method to get shadow with custom color and intensity
  static BoxShadow getShadow(
    Color color, {
    double blurRadius = 10,
    double spreadRadius = 2,
    double opacity = 0.3,
  }) {
    return BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      offset: const Offset(0, 4),
    );
  }

  // Helper method to get glowing effect
  static BoxShadow getGlow(
    Color color, {
    double blurRadius = 15,
    double spreadRadius = 3,
    double opacity = 0.5,
  }) {
    return BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      offset: Offset.zero,
    );
  }

  // Helper method to get multiple shadows for depth effect
  static List<BoxShadow> getDepthShadows() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ];
  }

  // Helper method to get neon glow effect
  static List<BoxShadow> getNeonGlow(Color color) {
    return [
      BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, spreadRadius: 2),
      BoxShadow(color: color.withOpacity(0.2), blurRadius: 16, spreadRadius: 4),
    ];
  }

  // Helper method to get glassmorphism background
  static BoxDecoration getGlassmorphismDecoration({
    required bool isDarkMode,
    double borderRadius = 16,
    Color? borderColor,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDarkMode
            ? [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]
            : [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.85)],
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color:
            borderColor ??
            (isDarkMode ? Colors.white.withOpacity(0.2) : Colors.white),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: (isDarkMode ? Colors.cyan : Colors.green).withOpacity(0.15),
          blurRadius: 12,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Helper method for gradient button style
  static BoxDecoration getGradientButtonDecoration({
    required Color startColor,
    required Color endColor,
    double borderRadius = 12,
    bool withShadow = true,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [startColor, endColor],
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: withShadow
          ? [
              BoxShadow(
                color: startColor.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ]
          : null,
    );
  }

  // Helper method for shimmer effect
  static LinearGradient getShimmerGradient() {
    return const LinearGradient(
      begin: Alignment(-1.0, -0.3),
      end: Alignment(1.0, -0.3),
      colors: [Color(0xFFE0E0E0), Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
      stops: [0.0, 0.5, 1.0],
    );
  }
}
