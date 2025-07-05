import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../infrastructure/services/theme_service.dart';
import '../../infrastructure/services/syntax_highlighting_service.dart';
import '../../core/di/injection_container.dart' as di;

/// Minimal and beautiful settings page focused on IDE themes
///
/// This redesigned settings page features:
/// - Clean minimal design with focused sections
/// - IDE theme previews with colored circles
/// - Integration with advanced syntax highlighting themes
/// - Professional developer-focused interface
/// - Smooth animations and modern Material 3 design
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedCodeTheme = 'github_enhanced';

  /// IDE themes with their preview colors and descriptions
  static const Map<String, Map<String, dynamic>> _ideThemes = {
    'github_enhanced': {
      'name': 'GitHub Enhanced',
      'description': 'Clean and professional light theme',
      'colors': [
        Color(0xFFfafbfc),
        Color(0xFFd73a49),
        Color(0xFF032f62),
        Color(0xFF6a737d),
      ],
      'isDark': false,
    },
    'atom_one_dark_enhanced': {
      'name': 'Atom One Dark Enhanced',
      'description': 'Popular dark theme from Atom editor',
      'colors': [
        Color(0xFF282c34),
        Color(0xFFc678dd),
        Color(0xFF98c379),
        Color(0xFF61afef),
      ],
      'isDark': true,
    },
    'dracula_beautiful': {
      'name': 'Dracula Beautiful',
      'description': 'Dark theme with vibrant colors',
      'colors': [
        Color(0xFF282a36),
        Color(0xFFff79c6),
        Color(0xFFf1fa8c),
        Color(0xFF50fa7b),
      ],
      'isDark': true,
    },
    'monokai_pro': {
      'name': 'Monokai Pro',
      'description': 'Modern take on the classic Monokai',
      'colors': [
        Color(0xFF2d2a2e),
        Color(0xFFff6188),
        Color(0xFFffd866),
        Color(0xFFa9dc76),
      ],
      'isDark': true,
    },
    'oceanic_next': {
      'name': 'Oceanic Next',
      'description': 'Calm oceanic dark theme',
      'colors': [
        Color(0xFF1b2b34),
        Color(0xFFc594c5),
        Color(0xFF99c794),
        Color(0xFF6699cc),
      ],
      'isDark': true,
    },
    'nord_theme': {
      'name': 'Nord Theme',
      'description': 'Arctic-inspired minimal theme',
      'colors': [
        Color(0xFF2e3440),
        Color(0xFF81a1c1),
        Color(0xFFa3be8c),
        Color(0xFF88c0d0),
      ],
      'isDark': true,
    },
    'tokyo_night': {
      'name': 'Tokyo Night',
      'description': 'Clean dark theme inspired by Tokyo nights',
      'colors': [
        Color(0xFF1a1b26),
        Color(0xFFbb9af7),
        Color(0xFF9ece6a),
        Color(0xFF7aa2f7),
      ],
      'isDark': true,
    },
    'gruvbox_dark': {
      'name': 'Gruvbox Dark',
      'description': 'Retro groove color scheme',
      'colors': [
        Color(0xFF282828),
        Color(0xFFfb4934),
        Color(0xFFb8bb26),
        Color(0xFF83a598),
      ],
      'isDark': true,
    },
    'synthwave84': {
      'name': 'Synthwave \'84',
      'description': 'Retro-futuristic neon theme',
      'colors': [
        Color(0xFF2a2139),
        Color(0xFFff7edb),
        Color(0xFFfede5d),
        Color(0xFF36f9f6),
      ],
      'isDark': true,
    },
    'material_theme': {
      'name': 'Material Theme',
      'description': 'Google Material Design inspired',
      'colors': [
        Color(0xFF263238),
        Color(0xFFC792EA),
        Color(0xFFC3E88D),
        Color(0xFF82AAFF),
      ],
      'isDark': true,
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();

    // Load the currently selected theme and run debug checks
    _loadSelectedTheme();
    _runDebugChecks();
  }

  /// Run debug checks to verify settings functionality
  Future<void> _runDebugChecks() async {
    try {
      final syntaxService = di.sl<SyntaxHighlightingService>();
      await syntaxService.debugSettingsStatus();
      await syntaxService.testSettingsPersistence();
    } catch (e) {
      debugPrint('Debug checks failed: $e');
    }
  }

  /// Load the currently selected theme from SyntaxHighlightingService
  Future<void> _loadSelectedTheme() async {
    try {
      // Use the properly initialized singleton from DI container
      final syntaxService = di.sl<SyntaxHighlightingService>();

      final currentTheme = syntaxService.selectedTheme;
      if (_ideThemes.containsKey(currentTheme)) {
        setState(() {
          _selectedCodeTheme = currentTheme;
        });
        debugPrint('Loaded theme from settings: $currentTheme');
      } else {
        debugPrint(
          'Theme $currentTheme not found in available themes, using fallback',
        );
        setState(() {
          _selectedCodeTheme = 'github_enhanced';
        });
      }
    } catch (e) {
      debugPrint('Failed to load selected theme: $e');
      setState(() {
        _selectedCodeTheme = 'github_enhanced'; // fallback
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                // Minimal app bar
                _buildMinimalAppBar(context, themeService),

                // Settings content
                SliverPadding(
                  padding: const EdgeInsets.all(24.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildAppearanceSection(context, themeService),
                      const SizedBox(height: 32),
                      _buildCodeThemeSection(context, themeService),
                      const SizedBox(height: 32),
                      _buildAccessibilitySection(context, themeService),
                      const SizedBox(height: 100), // Extra space at bottom
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build minimal app bar
  Widget _buildMinimalAppBar(BuildContext context, ThemeService themeService) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
      ),
    );
  }

  /// Build appearance section
  Widget _buildAppearanceSection(
    BuildContext context,
    ThemeService themeService,
  ) {
    return _buildSection(
      context,
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [_buildThemeModeOption(context, themeService)],
    );
  }

  /// Build code theme section with IDE theme previews
  Widget _buildCodeThemeSection(
    BuildContext context,
    ThemeService themeService,
  ) {
    return _buildSection(
      context,
      title: 'Code Editor Themes',
      icon: Icons.code_rounded,
      children: [
        Text(
          'Choose your preferred IDE theme for syntax highlighting',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),

        // Code preview section
        _buildCodePreviewSection(context),
        const SizedBox(height: 24),

        // Theme options
        ..._ideThemes.entries.map(
          (entry) => _buildIdeThemeOption(
            context,
            themeService,
            entry.key,
            entry.value,
          ),
        ),
      ],
    );
  }

  /// Build code preview section showing the selected theme in action
  Widget _buildCodePreviewSection(BuildContext context) {
    final selectedTheme = _ideThemes[_selectedCodeTheme]!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selectedTheme['colors'][0] as Color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: (selectedTheme['colors'][1] as Color).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with theme name and language
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (selectedTheme['colors'][1] as Color).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Flutter/Dart',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: selectedTheme['colors'][1] as Color,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
              ),
              const Spacer(),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (selectedTheme['colors'][2] as Color).withOpacity(
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    selectedTheme['name'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: (selectedTheme['colors'][2] as Color).withOpacity(
                        0.8,
                      ),
                      fontFamily: 'JetBrains Mono',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Code sample with animated transitions
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: RichText(
              key: ValueKey(_selectedCodeTheme),
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'JetBrains Mono',
                  height: 1.4,
                  color: selectedTheme['colors'][3] as Color,
                ),
                children: [
                  TextSpan(
                    text: 'class ',
                    style: TextStyle(
                      color: selectedTheme['colors'][1] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: 'CodeAssistant',
                    style: TextStyle(
                      color: selectedTheme['colors'][2] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' {\n'),
                  TextSpan(
                    text: '  final String ',
                    style: TextStyle(
                      color: selectedTheme['colors'][1] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: 'theme',
                    style: TextStyle(
                      color: selectedTheme['colors'][3] as Color,
                    ),
                  ),
                  const TextSpan(text: ';\n\n'),
                  TextSpan(
                    text: '  String ',
                    style: TextStyle(
                      color: selectedTheme['colors'][1] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: 'generateCode',
                    style: TextStyle(
                      color: selectedTheme['colors'][3] as Color,
                    ),
                  ),
                  const TextSpan(text: '('),
                  TextSpan(
                    text: 'String ',
                    style: TextStyle(
                      color: selectedTheme['colors'][1] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: 'prompt',
                    style: TextStyle(
                      color: selectedTheme['colors'][3] as Color,
                    ),
                  ),
                  const TextSpan(text: ') {\n'),
                  TextSpan(
                    text: '    return ',
                    style: TextStyle(
                      color: selectedTheme['colors'][1] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '"Beautiful \${theme} theme!"',
                    style: TextStyle(
                      color: selectedTheme['colors'][2] as Color,
                    ),
                  ),
                  const TextSpan(text: ';\n'),
                  const TextSpan(text: '  }\n'),
                  const TextSpan(text: '}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build accessibility section
  Widget _buildAccessibilitySection(
    BuildContext context,
    ThemeService themeService,
  ) {
    return _buildSection(
      context,
      title: 'Accessibility',
      icon: Icons.accessibility_new_rounded,
      children: [_buildFontSizeOption(context, themeService)],
    );
  }

  /// Build section container
  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  /// Build theme mode option
  Widget _buildThemeModeOption(
    BuildContext context,
    ThemeService themeService,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme Mode',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose between light, dark, or system theme',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12), // Reduced from 16 to 12
        Flexible(
          // Wrap dropdown in Flexible
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ), // Reduced horizontal padding
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButton<ThemeMode>(
              value: themeService.themeMode,
              onChanged: (ThemeMode? mode) {
                if (mode != null) {
                  themeService.setThemeMode(mode);
                }
              },
              underline: const SizedBox.shrink(),
              isDense: true, // Make dropdown more compact
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 18, // Reduced from 20 to 18
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                // Changed from bodyMedium to bodySmall
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build IDE theme option with colored preview circles
  Widget _buildIdeThemeOption(
    BuildContext context,
    ThemeService themeService,
    String themeKey,
    Map<String, dynamic> themeData,
  ) {
    final isSelected = _selectedCodeTheme == themeKey;
    final colors = themeData['colors'] as List<Color>;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            debugPrint('=== Theme Selection Started ===');
            debugPrint('User selected theme: $themeKey');

            setState(() {
              _selectedCodeTheme = themeKey;
            });

            // Save the selected theme using enhanced persistence
            try {
              final syntaxService = di.sl<SyntaxHighlightingService>();

              debugPrint('Retrieved SyntaxHighlightingService from DI');
              debugPrint(
                'Current service theme before save: ${syntaxService.selectedTheme}',
              );

              await syntaxService.setSelectedTheme(themeKey);

              debugPrint('Theme save operation completed');
              debugPrint(
                'Current service theme after save: ${syntaxService.selectedTheme}',
              );

              // Verify the save by checking stored value
              await syntaxService.debugSettingsStatus();

              debugPrint('Theme "$themeKey" saved successfully');

              // Show enhanced feedback to user
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.palette_rounded,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Theme Applied',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${themeData['name']} is now active across all code previews',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    elevation: 6,
                  ),
                );
              }
            } catch (e) {
              debugPrint('Failed to save theme: $e');
              debugPrint('Error type: ${e.runtimeType}');
              debugPrint('Error stack trace: ${StackTrace.current}');

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: Theme.of(context).colorScheme.onError,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Failed to save theme settings: ${e.toString()}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onError,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    duration: const Duration(seconds: 4),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            }

            debugPrint('=== Theme Selection Completed ===');
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
                      : Colors.transparent,
            ),
            child: Row(
              children: [
                // Theme color preview circles - Make flexible to prevent overflow
                Flexible(
                  flex: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        colors
                            .take(4)
                            .map(
                              (color) => Container(
                                margin: const EdgeInsets.only(
                                  right: 6,
                                ), // Reduced from 8 to 6
                                width: 20, // Reduced from 24 to 20
                                height: 20, // Reduced from 24 to 20
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline.withOpacity(0.2),
                                    width: 0.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                const SizedBox(width: 12), // Reduced from 16 to 12
                // Theme info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        themeData['name'],
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        themeData['description'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8), // Add small spacing before icon
                // Selection indicator with animation
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child:
                      isSelected
                          ? Icon(
                            Icons.check_circle_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 22, // Reduced from 24 to 22
                            key: const ValueKey('selected'),
                          )
                          : Icon(
                            Icons.radio_button_unchecked,
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withOpacity(0.5),
                            size: 22, // Reduced from 24 to 22
                            key: const ValueKey('unselected'),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build font size option
  Widget _buildFontSizeOption(BuildContext context, ThemeService themeService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Font Size',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Adjust text size for better readability',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8), // Reduced width for spacing
            Flexible(
              // Wrap percentage text in Flexible
              child: Text(
                '${(themeService.fontSizeScale * 100).round()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.text_decrease_rounded,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                size: 18, // Reduced from 20 to 18
              ),
              const SizedBox(width: 8), // Add spacing
              Expanded(
                child: Slider(
                  value: themeService.fontSizeScale,
                  min: 0.8,
                  max: 1.3,
                  divisions: 10,
                  onChanged: (value) {
                    themeService.setFontSizeScale(value);
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              const SizedBox(width: 8), // Add spacing
              Icon(
                Icons.text_increase_rounded,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                size: 18, // Reduced from 20 to 18
              ),
            ],
          ),
        ),
      ],
    );
  }
}
