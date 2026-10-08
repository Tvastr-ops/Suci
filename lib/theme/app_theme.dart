import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPalette {
  final String id;
  final String label;
  final Color primary;

  const AppPalette({
    required this.id,
    required this.label,
    required this.primary,
  });
}

class AppPalettes {
  static const teal = AppPalette(
    id: 'teal',
    label: 'Sage Teal',
    primary: Color(0xFF2C6E63),
  );

  static const sakura = AppPalette(
    id: 'sakura',
    label: 'Sakura Rose',
    primary: Color(0xFFB9536B),
  );

  static const indigo = AppPalette(
    id: 'indigo',
    label: 'Midnight Indigo',
    primary: Color(0xFF3F51B5),
  );

  static const amber = AppPalette(
    id: 'amber',
    label: 'Literary Amber',
    primary: Color(0xFFC27803),
  );

  static const violet = AppPalette(
    id: 'violet',
    label: 'Amethyst Violet',
    primary: Color(0xFF6750A4),
  );

  static const crimson = AppPalette(
    id: 'crimson',
    label: 'Crimson Rust',
    primary: Color(0xFF9C413D),
  );

  static const slate = AppPalette(
    id: 'slate',
    label: 'Obsidian Slate',
    primary: Color(0xFF455A64),
  );

  static const List<AppPalette> all = [
    teal,
    sakura,
    indigo,
    amber,
    violet,
    crimson,
    slate,
  ];

  static AppPalette fromId(String? id) {
    return all.firstWhere((p) => p.id == id, orElse: () => teal);
  }
}

class AppTheme {
  static const Color defaultSeedColor = Color(0xFF2C6E63);

  static TextTheme _buildTextTheme(ColorScheme scheme) {
    final baseTextTheme = Typography.material2021(platform: TargetPlatform.android).black.apply(
      displayColor: scheme.onSurface,
      bodyColor: scheme.onSurface,
    );

    final pjs = GoogleFonts.plusJakartaSansTextTheme(baseTextTheme);

    return pjs.copyWith(
      displayLarge: pjs.displayLarge?.copyWith(
        letterSpacing: -1.0,
        fontWeight: FontWeight.w700,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      displayMedium: pjs.displayMedium?.copyWith(
        letterSpacing: -0.8,
        fontWeight: FontWeight.w700,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      displaySmall: pjs.displaySmall?.copyWith(
        letterSpacing: -0.6,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      headlineLarge: pjs.headlineLarge?.copyWith(
        letterSpacing: -0.6,
        fontWeight: FontWeight.w600,
        height: 1.2,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      headlineMedium: pjs.headlineMedium?.copyWith(
        letterSpacing: -0.5,
        fontWeight: FontWeight.w600,
        height: 1.2,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      headlineSmall: pjs.headlineSmall?.copyWith(
        letterSpacing: -0.4,
        fontWeight: FontWeight.w600,
        height: 1.25,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      titleLarge: pjs.titleLarge?.copyWith(
        letterSpacing: -0.3,
        fontWeight: FontWeight.w600,
        height: 1.25,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      titleMedium: pjs.titleMedium?.copyWith(
        letterSpacing: -0.2,
        fontWeight: FontWeight.w600,
        height: 1.3,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      titleSmall: pjs.titleSmall?.copyWith(
        letterSpacing: -0.1,
        fontWeight: FontWeight.w500,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      bodyLarge: pjs.bodyLarge?.copyWith(
        letterSpacing: 0.0,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      bodyMedium: pjs.bodyMedium?.copyWith(
        letterSpacing: 0.0,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      bodySmall: pjs.bodySmall?.copyWith(
        letterSpacing: 0.1,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      labelLarge: pjs.labelLarge?.copyWith(
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      labelMedium: pjs.labelMedium?.copyWith(
        letterSpacing: 0.2,
        fontWeight: FontWeight.w500,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      labelSmall: pjs.labelSmall?.copyWith(
        letterSpacing: 0.2,
        fontWeight: FontWeight.w500,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }

  static ThemeData lightTheme([ColorScheme? dynamicScheme, Color? customSeed]) {
    final scheme = dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: customSeed ?? defaultSeedColor,
          brightness: Brightness.light,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: _buildTextTheme(scheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData darkTheme([ColorScheme? dynamicScheme, Color? customSeed]) {
    final scheme = dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: customSeed ?? defaultSeedColor,
          brightness: Brightness.dark,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: _buildTextTheme(scheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.12),
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

