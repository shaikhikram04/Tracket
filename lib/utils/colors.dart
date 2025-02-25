import 'package:flutter/material.dart';

//* Brand Colors - Cricket Theme
const Color primaryColor = Color(0xFF1B8E3D); // Professional cricket green
const Color primaryVariant = Color(0xFF146E2F); // Darker green for depth
const Color primaryLight = Color(0xFF47B16C); // Lighter green for accents
const Color primaryMedium = Color(0xFF219B48); // Medium green for balance
const Color onPrimary = Color(0xFFF5F7F5);

//* Secondary Color Scheme
const Color secondaryColor = Color(0xFF3498DB); // Blue accent
const Color secondaryVariant = Color(0xFF2980B9); // Darker blue
const Color secondaryLight = Color(0xFF5DADE2); // Lighter blue

// Field and Pitch inspired colors
const grassGreen = Color(0xFF2E7D32); // Natural grass color
const darkGrassGreen = const Color(0xFF1B5E20);
const pitchBrown = Color(0xFFB87A3D); // Cricket pitch color
const lightPitchBrown = Color(0xFFBCAAA4); // Light brown
const boundaryRope = Color(0xFFE57373); // Boundary rope inspired

//* Light Mode Colors
class LightThemeColors {
  // Background hierarchy
  static const backgroundColor = Color(0xFFF5F7F5); // Subtle green tint
  static const surfaceColor = Color(0xFFFFFFFF);
  static const cardColor = Color(0xFFE8F5E9); // Soft green cards
  static const dividerColor = Color(0xFFE0E0E0);
  static const secondaryBackground = Color(0xFFF0F4F0);

  // Text colors
  static const primaryText = Color(0xFF1A1C19); // Near black
  static const secondaryText = Color(0xFF424242);
  static const tertiaryText = Color(0xFF666666);

  // Player role colors - Enhanced visibility
  static const batsmanColor = Color(0xFF1976D2); // Clear blue
  static const bowlerColor = Color(0xFFD32F2F); // Distinct red
  static const allRounderColor = Color(0xFF7B1FA2); // Royal purple
  static const wicketKeeperColor = Color(0xFFEF6C00); // Bright orange
}

//* Dark Mode Colors
class DarkThemeColors {
  // Background hierarchy
  static const backgroundColor = Color(0xFF1A1C19);
  static const surfaceColor = Color(0xFF2A2C29);
  static const cardColor = Color(0xFF323631);
  static const secondaryBackground = Color(0xFF242623);

  // Text colors
  static const primaryText = Color(0xFFE6E6E6);
  static const secondaryText = Color(0xFFB3B3B3);
  static const tertiaryText = Color(0xFF999999);

  // Player role colors - Dark mode optimized
  static const batsmanColor = Color(0xFF64B5F6);
  static const bowlerColor = Color(0xFFE57373);
  static const allRounderColor = Color(0xFFCE93D8);
  static const wicketKeeperColor = Color(0xFFFFB74D);
}

//* Status Colors - Both Modes
class StatusColors {
  // Match states
  static const liveMatch = Color(0xFF4CAF50);
  static const upcoming = Color(0xFF2196F3);
  static const completed = Color(0xFF757575);

  // Performance indicators
  static const success = Color(0xFF43A047);
  static const warning = Color(0xFFFFA000);
  static const error = Color(0xFFE53935);
  static const info = Color(0xFF1E88E5);
}

//* Interactive Elements
class InteractiveColors {
  // Buttons
  static const buttonEnabled = Color(0xFF1B8E3D);
  static const buttonPressed = Color(0xFF146E2F);
  static const buttonDisabled = Color(0xFFBDBDBD);
  static const buttonDisabledSecondary = Color(0xFFDFCDCD);

  // Selection states
  static const selected = Color(0xFF47B16C);
  static const unselected = Color(0xFF757575);
  static const focused = Color(0xFF219B48);

  // Input fields
  static const inputBorder = Color(0xFF2E7D32);
  static const inputFilled = Color(0xFFF5F7F5);
  static const inputError = Color(0xFFE53935);
}

//* Gradients
class GradientColors {
  static const matchCardStart = Color(0xFF1B8E3D);
  static const matchCardEnd = Color(0xFF47B16C);

  static const darkModeStart = Color(0xFF146E2F);
  static const darkModeEnd = Color(0xFF1B8E3D);
}
