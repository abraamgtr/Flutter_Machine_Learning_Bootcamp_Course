import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app theme and user preferences
///
/// This service handles theme management including dark/light mode toggle,
/// color scheme preferences, and font size settings. It persists user
/// preferences using SharedPreferences.
class ThemeService extends ChangeNotifier {
  /// SharedPreferences instance for persistent storage
  late SharedPreferences _prefs;

  /// Key for storing theme mode preference
  static const String _themeModeKey = 'theme_mode';

  /// Key for storing font size preference
  static const String _fontSizeKey = 'font_size';

  /// Key for storing color scheme preference
  static const String _colorSchemeKey = 'color_scheme';

  /// Key for storing first launch flag
  static const String _firstLaunchKey = 'first_launch';

  /// Current theme mode
  ThemeMode _themeMode = ThemeMode.system;

  /// Current font size scale
  double _fontSizeScale = 1.0;

  /// Current color scheme index
  int _colorSchemeIndex = 0;

  /// Whether this is the first app launch
  bool _isFirstLaunch = true;

  // Minimal Professional Color Schemes
  static const ColorScheme _minimalProfessionalLightGray = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2D3748),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF4A5568),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFE53E3E),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1A202C),
    surfaceContainerHighest: Color(0xFFF7FAFC),
    outline: Color(0xFFE2E8F0),
  );

  static const ColorScheme _minimalProfessionalDarkGray = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF9CA3AF),
    onPrimary: Color(0xFF1F2937),
    secondary: Color(0xFF6B7280),
    onSecondary: Color(0xFF111827),
    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),
    surface: Color(0xFF111827),
    onSurface: Color(0xFFF9FAFB),
    surfaceContainerHighest: Color(0xFF1F2937),
    outline: Color(0xFF374151),
  );

  static const ColorScheme _minimalProfessionalWarmGray = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF4A5568),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF718096),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFE53E3E),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFF9),
    onSurface: Color(0xFF2D3748),
    surfaceContainerHighest: Color(0xFFFAF9F7),
    outline: Color(0xFFE2E8F0),
  );

  static const ColorScheme _minimalProfessionalDarkWarmGray = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFA78BFA),
    onPrimary: Color(0xFF2D1B69),
    secondary: Color(0xFF8B5CF6),
    onSecondary: Color(0xFF1E1B4B),
    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),
    surface: Color(0xFF0F0A1A),
    onSurface: Color(0xFFF3F4F6),
    surfaceContainerHighest: Color(0xFF1E1B4B),
    outline: Color(0xFF4C1D95),
  );

  static const ColorScheme _minimalProfessionalBlueGray = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF334155),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF64748B),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFE),
    onSurface: Color(0xFF1E293B),
    surfaceContainerHighest: Color(0xFFF8FAFC),
    outline: Color(0xFFE2E8F0),
  );

  static const ColorScheme _minimalProfessionalDarkBlueGray = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF60A5FA),
    onPrimary: Color(0xFF1E3A8A),
    secondary: Color(0xFF3B82F6),
    onSecondary: Color(0xFF1E40AF),
    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),
    surface: Color(0xFF0F172A),
    onSurface: Color(0xFFF1F5F9),
    surfaceContainerHighest: Color(0xFF1E293B),
    outline: Color(0xFF334155),
  );

  // Vibrant Color Schemes
  static const ColorScheme _vibrantSunsetLight = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFEA580C),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFDC2626),
    onSecondary: Color(0xFFFFFFFF),
    tertiary: Color(0xFF9333EA),
    onTertiary: Color(0xFFFFFFFF),
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFF7ED),
    onSurface: Color(0xFF9A3412),
    surfaceContainer: Color(0xFFFED7AA),
    surfaceContainerHighest: Color(0xFFFFEDD5),
    primaryContainer: Color(0xFFFF9B5A),
    secondaryContainer: Color(0xFFFC8181),
    tertiaryContainer: Color(0xFFC084FC),
    outline: Color(0xFFD97706),
  );

  static const ColorScheme _vibrantSunsetDark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFF9B5A),
    onPrimary: Color(0xFF7C2D12),
    secondary: Color(0xFFFC8181),
    onSecondary: Color(0xFF7F1D1D),
    tertiary: Color(0xFFC084FC),
    onTertiary: Color(0xFF581C87),
    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),
    surface: Color(0xFF1C0A00),
    onSurface: Color(0xFFFFEDD5),
    surfaceContainer: Color(0xFF431407),
    surfaceContainerHighest: Color(0xFF7C2D12),
    primaryContainer: Color(0xFFEA580C),
    secondaryContainer: Color(0xFFDC2626),
    tertiaryContainer: Color(0xFF9333EA),
    outline: Color(0xFFEA580C),
  );

  static const ColorScheme _oceanDepthsLight = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0891B2),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF06B6D4),
    onSecondary: Color(0xFFFFFFFF),
    tertiary: Color(0xFF0D9488),
    onTertiary: Color(0xFFFFFFFF),
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFF0FDFF),
    onSurface: Color(0xFF164E63),
    surfaceContainer: Color(0xFFBAE6FD),
    surfaceContainerHighest: Color(0xFFE0F7FA),
    primaryContainer: Color(0xFF67E8F9),
    secondaryContainer: Color(0xFF99F6E4),
    tertiaryContainer: Color(0xFF5EEAD4),
    outline: Color(0xFF0284C7),
  );

  static const ColorScheme _oceanDepthsDark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF67E8F9),
    onPrimary: Color(0xFF164E63),
    secondary: Color(0xFF99F6E4),
    onSecondary: Color(0xFF134E4A),
    tertiary: Color(0xFF5EEAD4),
    onTertiary: Color(0xFF115E59),
    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),
    surface: Color(0xFF0C1419),
    onSurface: Color(0xFFE0F7FA),
    surfaceContainer: Color(0xFF164E63),
    surfaceContainerHighest: Color(0xFF0E7490),
    primaryContainer: Color(0xFF0891B2),
    secondaryContainer: Color(0xFF06B6D4),
    tertiaryContainer: Color(0xFF0D9488),
    outline: Color(0xFF0891B2),
  );

  static const ColorScheme _forestCanopyLight = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF059669),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF65A30D),
    onSecondary: Color(0xFFFFFFFF),
    tertiary: Color(0xFFA3A3A3),
    onTertiary: Color(0xFF404040),
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFF7FDF7),
    onSurface: Color(0xFF064E3B),
    surfaceContainer: Color(0xFFBBF7D0),
    surfaceContainerHighest: Color(0xFFD1FAE5),
    primaryContainer: Color(0xFF6EE7B7),
    secondaryContainer: Color(0xFFA7F3D0),
    tertiaryContainer: Color(0xFFD4D4D8),
    outline: Color(0xFF10B981),
  );

  static const ColorScheme _forestCanopyDark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF6EE7B7),
    onPrimary: Color(0xFF064E3B),
    secondary: Color(0xFFA7F3D0),
    onSecondary: Color(0xFF365314),
    tertiary: Color(0xFFD4D4D8),
    onTertiary: Color(0xFF262626),
    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),
    surface: Color(0xFF0A1F0A),
    onSurface: Color(0xFFD1FAE5),
    surfaceContainer: Color(0xFF064E3B),
    surfaceContainerHighest: Color(0xFF047857),
    primaryContainer: Color(0xFF059669),
    secondaryContainer: Color(0xFF65A30D),
    tertiaryContainer: Color(0xFFA3A3A3),
    outline: Color(0xFF059669),
  );

  static const ColorScheme _cosmicPurpleLight = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF7C3AED),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF8B5CF6),
    onSecondary: Color(0xFFFFFFFF),
    tertiary: Color(0xFFEC4899),
    onTertiary: Color(0xFFFFFFFF),
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFAF5FF),
    onSurface: Color(0xFF581C87),
    surfaceContainer: Color(0xFFDDD6FE),
    surfaceContainerHighest: Color(0xFFE9D5FF),
    primaryContainer: Color(0xFFA78BFA),
    secondaryContainer: Color(0xFFC4B5FD),
    tertiaryContainer: Color(0xFFF9A8D4),
    outline: Color(0xFF6D28D9),
  );

  static const ColorScheme _cosmicPurpleDark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFA78BFA),
    onPrimary: Color(0xFF581C87),
    secondary: Color(0xFFC4B5FD),
    onSecondary: Color(0xFF4C1D95),
    tertiary: Color(0xFFF9A8D4),
    onTertiary: Color(0xFF831843),
    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),
    surface: Color(0xFF1E1B4B),
    onSurface: Color(0xFFE9D5FF),
    surfaceContainer: Color(0xFF581C87),
    surfaceContainerHighest: Color(0xFF6D28D9),
    primaryContainer: Color(0xFF7C3AED),
    secondaryContainer: Color(0xFF8B5CF6),
    tertiaryContainer: Color(0xFFEC4899),
    outline: Color(0xFF7C3AED),
  );

  static const ColorScheme _cherryBlossomLight = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFEC4899),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFF472B6),
    onSecondary: Color(0xFF831843),
    tertiary: Color(0xFFFBBF24),
    onTertiary: Color(0xFF92400E),
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFDF2F8),
    onSurface: Color(0xFF831843),
    surfaceContainer: Color(0xFFFC6D77),
    surfaceContainerHighest: Color(0xFFFCE7F3),
    primaryContainer: Color(0xFFF9A8D4),
    secondaryContainer: Color(0xFFFBBF24),
    tertiaryContainer: Color(0xFFFEF3C7),
    outline: Color(0xFFDB2777),
  );

  static const ColorScheme _cherryBlossomDark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFF9A8D4),
    onPrimary: Color(0xFF831843),
    secondary: Color(0xFFFBBF24),
    onSecondary: Color(0xFF92400E),
    tertiary: Color(0xFFFC6D77),
    onTertiary: Color(0xFF7F1D1D),
    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),
    surface: Color(0xFF4C1D3D),
    onSurface: Color(0xFFFCE7F3),
    surfaceContainer: Color(0xFF831843),
    surfaceContainerHighest: Color(0xFF9D174D),
    primaryContainer: Color(0xFFEC4899),
    secondaryContainer: Color(0xFFF472B6),
    tertiaryContainer: Color(0xFFFBBF24),
    outline: Color(0xFFEC4899),
  );

  static const ColorScheme _electricBlueLight = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF3B82F6),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF1D4ED8),
    onSecondary: Color(0xFFFFFFFF),
    tertiary: Color(0xFF06B6D4),
    onTertiary: Color(0xFFFFFFFF),
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFEFF6FF),
    onSurface: Color(0xFF1E3A8A),
    surfaceContainer: Color(0xFF93C5FD),
    surfaceContainerHighest: Color(0xFFDBEAFE),
    primaryContainer: Color(0xFF60A5FA),
    secondaryContainer: Color(0xFF67E8F9),
    tertiaryContainer: Color(0xFF22D3EE),
    outline: Color(0xFF2563EB),
  );

  static const ColorScheme _electricBlueDark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF60A5FA),
    onPrimary: Color(0xFF1E3A8A),
    secondary: Color(0xFF67E8F9),
    onSecondary: Color(0xFF164E63),
    tertiary: Color(0xFF22D3EE),
    onTertiary: Color(0xFF155E75),
    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),
    surface: Color(0xFF0F1419),
    onSurface: Color(0xFFDBEAFE),
    surfaceContainer: Color(0xFF1E3A8A),
    surfaceContainerHighest: Color(0xFF1E40AF),
    primaryContainer: Color(0xFF3B82F6),
    secondaryContainer: Color(0xFF1D4ED8),
    tertiaryContainer: Color(0xFF06B6D4),
    outline: Color(0xFF3B82F6),
  );

  /// Available color schemes with enhanced vibrant options
  static const List<Map<String, dynamic>> _colorSchemes = [
    // Minimal Professional Themes (existing)
    {
      'name': 'Minimal Professional - Light Gray',
      'description': 'Clean whites with subtle grays for professional focus',
      'light': _minimalProfessionalLightGray,
      'dark': _minimalProfessionalDarkGray,
      'isMinimal': true,
    },
    {
      'name': 'Minimal Professional - Warm Gray',
      'description':
          'Sophisticated warm neutrals for comfortable long sessions',
      'light': _minimalProfessionalWarmGray,
      'dark': _minimalProfessionalDarkWarmGray,
      'isMinimal': true,
    },
    {
      'name': 'Minimal Professional - Blue Gray',
      'description': 'Professional blue-tinged grays for technical precision',
      'light': _minimalProfessionalBlueGray,
      'dark': _minimalProfessionalDarkBlueGray,
      'isMinimal': true,
    },

    // New Vibrant & Colorful Themes
    {
      'name': 'Vibrant Sunset',
      'description': 'Warm oranges and purples inspired by beautiful sunsets',
      'light': _vibrantSunsetLight,
      'dark': _vibrantSunsetDark,
      'isMinimal': false,
    },
    {
      'name': 'Ocean Depths',
      'description': 'Deep blues and teals reminiscent of ocean waters',
      'light': _oceanDepthsLight,
      'dark': _oceanDepthsDark,
      'isMinimal': false,
    },
    {
      'name': 'Forest Canopy',
      'description': 'Rich greens and earth tones for natural harmony',
      'light': _forestCanopyLight,
      'dark': _forestCanopyDark,
      'isMinimal': false,
    },
    {
      'name': 'Cosmic Purple',
      'description': 'Deep purples and cosmic colors for creative inspiration',
      'light': _cosmicPurpleLight,
      'dark': _cosmicPurpleDark,
      'isMinimal': false,
    },
    {
      'name': 'Cherry Blossom',
      'description': 'Soft pinks and warm tones for gentle creativity',
      'light': _cherryBlossomLight,
      'dark': _cherryBlossomDark,
      'isMinimal': false,
    },
    {
      'name': 'Electric Blue',
      'description': 'Bright electric blues for high-energy coding sessions',
      'light': _electricBlueLight,
      'dark': _electricBlueDark,
      'isMinimal': false,
    },
  ];

  /// Dark versions of the color schemes - Minimal & Professional
  static const List<ColorScheme> _darkColorSchemes = [
    // Minimal Professional Dark - Light Gray
    ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFA0AEC0),
      onPrimary: Color(0xFF1A202C),
      secondary: Color(0xFF718096),
      onSecondary: Color(0xFF2D3748),
      error: Color(0xFFF56565),
      onError: Color(0xFF1A202C),
      surface: Color(0xFF1A202C),
      onSurface: Color(0xFFF7FAFC),
      surfaceContainerHighest: Color(0xFF2D3748),
      outline: Color(0xFF4A5568),
    ),
    // Minimal Professional Dark - Warm Gray
    ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFA0AEC0),
      onPrimary: Color(0xFF2D3748),
      secondary: Color(0xFF9CA3AF),
      onSecondary: Color(0xFF374151),
      error: Color(0xFFF87171),
      onError: Color(0xFF1F2937),
      surface: Color(0xFF1F2937),
      onSurface: Color(0xFFF9FAFB),
      surfaceContainerHighest: Color(0xFF374151),
      outline: Color(0xFF4B5563),
    ),
    // Minimal Professional Dark - Blue Gray
    ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF94A3B8),
      onPrimary: Color(0xFF1E293B),
      secondary: Color(0xFF64748B),
      onSecondary: Color(0xFF334155),
      error: Color(0xFFF87171),
      onError: Color(0xFF0F172A),
      surface: Color(0xFF0F172A),
      onSurface: Color(0xFFF8FAFC),
      surfaceContainerHighest: Color(0xFF1E293B),
      outline: Color(0xFF475569),
    ),
  ];

  // Getters
  ThemeMode get themeMode => _themeMode;
  double get fontSizeScale => _fontSizeScale;
  int get colorSchemeIndex => _colorSchemeIndex;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Initializes the theme service
  ///
  /// Loads saved preferences and sets up the initial theme state.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadPreferences();
  }

  /// Gets the current light theme
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorSchemes[_colorSchemeIndex]['light'],
      fontFamily: 'Roboto',
      textTheme: _getTextTheme(false),
      appBarTheme: AppBarTheme(
        backgroundColor: _colorSchemes[_colorSchemeIndex]['light']?.surface,
        foregroundColor: _colorSchemes[_colorSchemeIndex]['light']?.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  /// Gets the current dark theme
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorSchemes[_colorSchemeIndex]['dark'],
      fontFamily: 'Roboto',
      textTheme: _getTextTheme(true),
      appBarTheme: AppBarTheme(
        backgroundColor: _colorSchemes[_colorSchemeIndex]['dark']?.surface,
        foregroundColor: _colorSchemes[_colorSchemeIndex]['dark']?.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  /// Sets the theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _prefs.setString(_themeModeKey, mode.name);
      notifyListeners();
    }
  }

  /// Toggles between light and dark mode
  Future<void> toggleTheme() async {
    final newMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Sets the font size scale
  Future<void> setFontSizeScale(double scale) async {
    if (_fontSizeScale != scale) {
      _fontSizeScale = scale.clamp(0.8, 1.4);
      await _prefs.setDouble(_fontSizeKey, _fontSizeScale);
      notifyListeners();
    }
  }

  /// Sets the color scheme
  Future<void> setColorScheme(int index) async {
    if (_colorSchemeIndex != index &&
        index >= 0 &&
        index < _colorSchemes.length) {
      _colorSchemeIndex = index;
      await _prefs.setInt(_colorSchemeKey, _colorSchemeIndex);
      notifyListeners();
    }
  }

  /// Marks the first launch as completed
  Future<void> completeFirstLaunch() async {
    if (_isFirstLaunch) {
      _isFirstLaunch = false;
      await _prefs.setBool(_firstLaunchKey, false);
      notifyListeners();
    }
  }

  /// Resets all theme preferences to defaults
  Future<void> resetToDefaults() async {
    _themeMode = ThemeMode.system;
    _fontSizeScale = 1.0;
    _colorSchemeIndex = 0;

    await Future.wait([
      _prefs.setString(_themeModeKey, _themeMode.name),
      _prefs.setDouble(_fontSizeKey, _fontSizeScale),
      _prefs.setInt(_colorSchemeKey, _colorSchemeIndex),
    ]);

    notifyListeners();
  }

  /// Gets available color scheme names
  List<String> get colorSchemeNames =>
      _colorSchemes.map((scheme) => scheme['name'] as String).toList();

  /// Gets the current color scheme for the given brightness
  ColorScheme getCurrentColorScheme(Brightness brightness) {
    return brightness == Brightness.dark
        ? _colorSchemes[_colorSchemeIndex]['dark']
        : _colorSchemes[_colorSchemeIndex]['light'];
  }

  /// Loads preferences from SharedPreferences
  Future<void> _loadPreferences() async {
    // Load theme mode
    final themeModeString = _prefs.getString(_themeModeKey);
    if (themeModeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.name == themeModeString,
        orElse: () => ThemeMode.system,
      );
    }

    // Load font size scale
    _fontSizeScale = _prefs.getDouble(_fontSizeKey) ?? 1.0;

    // Load color scheme
    _colorSchemeIndex = _prefs.getInt(_colorSchemeKey) ?? 0;
    if (_colorSchemeIndex < 0 || _colorSchemeIndex >= _colorSchemes.length) {
      _colorSchemeIndex = 0;
    }

    // Load first launch flag
    _isFirstLaunch = _prefs.getBool(_firstLaunchKey) ?? true;
  }

  /// Creates text theme with proper font scaling
  TextTheme _getTextTheme(bool isDark) {
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();
    final textTheme = baseTheme.textTheme;

    return textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(
        fontSize: (textTheme.displayLarge?.fontSize ?? 57) * _fontSizeScale,
      ),
      displayMedium: textTheme.displayMedium?.copyWith(
        fontSize: (textTheme.displayMedium?.fontSize ?? 45) * _fontSizeScale,
      ),
      displaySmall: textTheme.displaySmall?.copyWith(
        fontSize: (textTheme.displaySmall?.fontSize ?? 36) * _fontSizeScale,
      ),
      headlineLarge: textTheme.headlineLarge?.copyWith(
        fontSize: (textTheme.headlineLarge?.fontSize ?? 32) * _fontSizeScale,
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        fontSize: (textTheme.headlineMedium?.fontSize ?? 28) * _fontSizeScale,
      ),
      headlineSmall: textTheme.headlineSmall?.copyWith(
        fontSize: (textTheme.headlineSmall?.fontSize ?? 24) * _fontSizeScale,
      ),
      titleLarge: textTheme.titleLarge?.copyWith(
        fontSize: (textTheme.titleLarge?.fontSize ?? 22) * _fontSizeScale,
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        fontSize: (textTheme.titleMedium?.fontSize ?? 16) * _fontSizeScale,
      ),
      titleSmall: textTheme.titleSmall?.copyWith(
        fontSize: (textTheme.titleSmall?.fontSize ?? 14) * _fontSizeScale,
      ),
      bodyLarge: textTheme.bodyLarge?.copyWith(
        fontSize: (textTheme.bodyLarge?.fontSize ?? 16) * _fontSizeScale,
      ),
      bodyMedium: textTheme.bodyMedium?.copyWith(
        fontSize: (textTheme.bodyMedium?.fontSize ?? 14) * _fontSizeScale,
      ),
      bodySmall: textTheme.bodySmall?.copyWith(
        fontSize: (textTheme.bodySmall?.fontSize ?? 12) * _fontSizeScale,
      ),
      labelLarge: textTheme.labelLarge?.copyWith(
        fontSize: (textTheme.labelLarge?.fontSize ?? 14) * _fontSizeScale,
      ),
      labelMedium: textTheme.labelMedium?.copyWith(
        fontSize: (textTheme.labelMedium?.fontSize ?? 12) * _fontSizeScale,
      ),
      labelSmall: textTheme.labelSmall?.copyWith(
        fontSize: (textTheme.labelSmall?.fontSize ?? 11) * _fontSizeScale,
      ),
    );
  }
}
