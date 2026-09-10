import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central design system for Tinsu-Shops
/// Deep green + warm gold palette — friendly, trustworthy, practical
class AppTheme {
  AppTheme._();

  // ── Color tokens ─────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1B6B3A);       // Deep forest green
  static const Color primaryLight = Color(0xFF2D8A52);
  static const Color primaryContainer = Color(0xFFBEEFD1);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFFD4A017);     // Warm gold
  static const Color secondaryLight = Color(0xFFE8BB3F);
  static const Color secondaryContainer = Color(0xFFFFF0C2);
  static const Color onSecondary = Color(0xFF000000);

  static const Color background = Color(0xFFF4F6F3);    // Warm off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEEF1EE);

  static const Color onBackground = Color(0xFF1A1C1A);  // Dark charcoal
  static const Color onSurface = Color(0xFF1A1C1A);
  static const Color onSurfaceVariant = Color(0xFF43483F);

  static const Color success = Color(0xFF1B6B3A);
  static const Color warning = Color(0xFFD4A017);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  static const Color divider = Color(0xFFE0E4DF);
  static const Color outline = Color(0xFF73786E);
  static const Color shadow = Color(0x14000000);

  // Low stock badge
  static const Color lowStockBg = Color(0xFFFFF3E0);
  static const Color lowStockText = Color(0xFFE65100);
  static const Color outOfStockBg = Color(0xFFFFEBEE);
  static const Color outOfStockText = Color(0xFFB71C1C);

  // ── Dimensions ────────────────────────────────────────────────────────────
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  // ── Typography ────────────────────────────────────────────────────────────
  static const List<String> _ethiopicFallback = ['NotoSansEthiopic'];

  static TextTheme _buildTextTheme() {
    final base = GoogleFonts.outfitTextTheme();
    // Wrap each style with an Ethiopic fallback so Amharic glyphs render
    // correctly while Latin characters continue to use Outfit.
    T? eth<T extends TextStyle?>(T? style) =>
        style?.copyWith(fontFamilyFallback: _ethiopicFallback) as T?;

    return base.copyWith(
      displayLarge: eth(base.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: onBackground,
        letterSpacing: -1,
      )),
      displayMedium: eth(base.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: onBackground,
        letterSpacing: -0.5,
      )),
      headlineLarge: eth(base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: onBackground,
      )),
      headlineMedium: eth(base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: onBackground,
      )),
      headlineSmall: eth(base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: onBackground,
      )),
      titleLarge: eth(base.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: onBackground,
      )),
      titleMedium: eth(base.titleMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: onBackground,
      )),
      titleSmall: eth(base.titleSmall?.copyWith(
        fontWeight: FontWeight.w500,
        color: onSurfaceVariant,
      )),
      bodyLarge: eth(base.bodyLarge?.copyWith(
        color: onBackground,
      )),
      bodyMedium: eth(base.bodyMedium?.copyWith(
        color: onSurfaceVariant,
      )),
      bodySmall: eth(base.bodySmall?.copyWith(
        color: onSurfaceVariant,
      )),
      labelLarge: eth(base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      )),
    );
  }

  // ── Light Theme ───────────────────────────────────────────────────────────
  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Color(0xFF002111),
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: Color(0xFF251A00),
      tertiary: Color(0xFF006874),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFF97F0FF),
      onTertiaryContainer: Color(0xFF001F24),
      error: error,
      onError: Colors.white,
      errorContainer: errorContainer,
      onErrorContainer: Color(0xFF410002),
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      shadow: shadow,
      inverseSurface: Color(0xFF2F312D),
      onInverseSurface: Color(0xFFF0F2EB),
      inversePrimary: Color(0xFF74DB96),
    );

    final textTheme = _buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: onBackground,
        ),
        iconTheme: const IconThemeData(color: onBackground),
        surfaceTintColor: Colors.transparent,
      ),

      // Card
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: divider, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
        ),
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: textTheme.bodyLarge?.copyWith(color: outline),
        labelStyle: textTheme.bodyMedium,
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: outline,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: textTheme.labelLarge?.copyWith(fontSize: 12),
        unselectedLabelStyle: textTheme.labelLarge?.copyWith(fontSize: 12),
      ),

      // NavigationBar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary, size: 24);
          }
          return const IconThemeData(color: outline, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelLarge?.copyWith(
              fontSize: 12,
              color: primary,
              fontWeight: FontWeight.w600,
            );
          }
          return textTheme.labelLarge?.copyWith(
            fontSize: 12,
            color: outline,
          );
        }),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 4,
        shape: StadiumBorder(),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: primaryContainer,
        labelStyle: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: const BorderSide(color: divider),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: onBackground,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.all(16),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
    );
  }
}
