import 'package:code_muse/features/feature_history/presentation/history_page.dart';
import 'package:code_muse/features/feature_homepage/presentation/provider/code_generation_provider.dart';
import 'package:code_muse/features/feature_settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:code_muse/core/services/theme_service.dart';
import 'package:code_muse/injection_container.dart' as di;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Modern application navigation drawer
///
/// This drawer provides enhanced access to:
/// - Generation history with visual indicators
/// - App settings and theme preferences
/// - Help resources and quick actions
/// - Smooth animations and transitions
/// - Beautiful Material 3 design elements
class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    // Start animation when drawer opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = di.sl<ThemeService>();

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Enhanced drawer header
            _buildModernDrawerHeader(context, theme, themeService),

            // Navigation items with animations
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                children: [
                  // Main navigation section
                  _buildSectionHeader(context, 'Navigation'),

                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 400),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(20 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: _buildModernListTile(
                            context,
                            icon: Icons.history_rounded,
                            title: 'Generation History',
                            subtitle: 'View previous generations',
                            onTap: () => _navigateToHistory(context),
                          ),
                        ),
                      );
                    },
                  ),

                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(20 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: _buildModernListTile(
                            context,
                            icon: Icons.settings_rounded,
                            title: 'Settings',
                            subtitle: 'Themes, preferences & more',
                            onTap: () => _navigateToSettings(context),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Quick actions section
                  _buildSectionHeader(context, 'Quick Actions'),

                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(20 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: _buildQuickActionsGrid(context, themeService),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Help & Support section
                  _buildSectionHeader(context, 'Help & Support'),

                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 700),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(20 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: _buildModernListTile(
                            context,
                            icon: Icons.help_outline_rounded,
                            title: 'Help & FAQ',
                            subtitle: 'Get help and tips',
                            onTap: () => _showHelpDialog(context),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Enhanced footer
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 900),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: _buildModernDrawerFooter(context, theme),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the modern drawer header with enhanced design
  Widget _buildModernDrawerHeader(
    BuildContext context,
    ThemeData theme,
    ThemeService themeService,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
            theme.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // App icon and branding - Minimal design
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.code_rounded,
                      size: 24,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CodeMuse',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Code Assistant',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Builds a modern list tile with enhanced design
  Widget _buildModernListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing,
                ] else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the quick actions grid
  Widget _buildQuickActionsGrid(
    BuildContext context,
    ThemeService themeService,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon:
                        themeService.isDarkMode
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                    label: 'Toggle Theme',
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      themeService.toggleTheme();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon: Icons.settings_rounded,
                    label: 'Preferences',
                    onTap: () => _navigateToSettings(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a quick action card
  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color:
            enabled
                ? theme.colorScheme.surfaceContainerLow
                : theme.colorScheme.surfaceContainerLow.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color:
                      enabled
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.4),
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color:
                          enabled
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the modern drawer footer
  Widget _buildModernDrawerFooter(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surfaceContainerHigh,
            theme.colorScheme.surfaceContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.school_rounded,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Educational Project',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Version 1.0.0 • Built with Flutter',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_rounded, size: 14, color: Colors.red),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Made with love for learning',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates to the history page
  void _navigateToHistory(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const HistoryPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          );
        },
      ),
    );
  }

  /// Navigates to the settings page
  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const SettingsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          );
        },
      ),
    );
  }

  /// Shows the help dialog with beautiful design
  void _showHelpDialog(BuildContext context) {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.help_outline_rounded,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Help & Tips'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHelpItem(
                  '📝',
                  'Be specific in your prompts for better results',
                ),
                _buildHelpItem('🎯', 'Choose the right programming language'),
                _buildHelpItem('📋', 'Copy code easily with the copy button'),
                _buildHelpItem('🎨', 'Switch themes for comfortable coding'),
                _buildHelpItem('📚', 'View your generation history anytime'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got it!'),
              ),
            ],
          ),
    );
  }

  /// Builds a help item
  Widget _buildHelpItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  /// Shows the clear history dialog
  void _showClearHistoryDialog(
    BuildContext context,
    CodeGenerationProvider provider,
  ) {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Clear History'),
              ],
            ),
            content: Text(
              'Are you sure you want to clear all ${provider.history.length} items from your generation history? This action cannot be undone.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  provider.clearHistory();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('History cleared successfully'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Clear All'),
              ),
            ],
          ),
    );
  }
}
