import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/di/injection_container.dart' as di;
import '../../domain/usecases/get_code_from_prompt_usecase.dart';
import '../../infrastructure/services/history_service.dart';
import '../../infrastructure/services/theme_service.dart';
import '../providers/code_generation_provider.dart';
import '../widgets/code_display_widget.dart';
import '../widgets/prompt_input_widget.dart';
import '../widgets/app_drawer.dart';

/// Main home page of the DeepSeek Code Assistant App
///
/// This page provides the core functionality for code generation including:
/// - Prompt input interface with modern design
/// - Code generation and display with beautiful animations
/// - Loading states and error handling with visual feedback
/// - Theme toggle and settings access with smooth transitions
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CodeGenerationProvider>(
      create:
          (_) => CodeGenerationProvider(
            di.sl<GetCodeFromPromptUseCase>(),
            di.sl<HistoryService>(),
          ),
      child: const _HomePageContent(),
    );
  }
}

/// Internal content widget for the home page
class _HomePageContent extends StatefulWidget {
  const _HomePageContent();

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Start the animations with staggered effect
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        _slideController.forward();
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text(
            'CodeMuse',
            style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        actions: [
          // Theme toggle with animation
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _fadeAnimation.value,
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return RotationTransition(turns: animation, child: child);
                    },
                    child: Icon(
                      themeService.isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      key: ValueKey(themeService.isDarkMode),
                    ),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    themeService.toggleTheme();
                  },
                  tooltip: 'Toggle theme',
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              );
            },
          ),
          // Connection status with pulse animation
          Consumer<CodeGenerationProvider>(
            builder: (context, provider, _) {
              // Use cached status first, then test if needed
              final cachedStatus = provider.cachedConnectionStatus;
              final isConnected = cachedStatus ?? false;

              // Only test connection once on first build if no cached status
              if (cachedStatus == null && !provider.isTestingConnection) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  provider.testConnection();
                });
              }

              return AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        // Manual refresh of connection status
                        provider.forceTestConnection();
                      },
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(seconds: 2),
                        tween: Tween(begin: 0.5, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: isConnected ? value : 1.0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    provider.isTestingConnection
                                        ? Colors.orange.withOpacity(0.1)
                                        : isConnected
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:
                                  provider.isTestingConnection
                                      ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.orange,
                                              ),
                                        ),
                                      )
                                      : Icon(
                                        isConnected
                                            ? Icons.cloud_done_rounded
                                            : Icons.cloud_off_rounded,
                                        color:
                                            isConnected
                                                ? Colors.green
                                                : Colors.red,
                                        size: 20,
                                      ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),

      drawer: const AppDrawer(),

      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(20.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Welcome card with hero animation
                      Hero(
                        tag: 'welcome_card',
                        child: Material(
                          color: Colors.transparent,
                          child: _buildModernWelcomeCard(context),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Prompt input section with staggered animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: const PromptInputWidget(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Code display section with entrance animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: const CodeDisplayWidget(),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 100), // Space for FAB
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Enhanced floating action button
      floatingActionButton: Consumer<CodeGenerationProvider>(
        builder: (context, provider, _) {
          if (!provider.hasResult) return const SizedBox.shrink();

          return TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    _copyToClipboard(context, provider.generatedCode);
                  },
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text(
                    'Copy Code',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  tooltip: 'Copy generated code to clipboard',
                  elevation: 6,
                  heroTag: "copy_fab",
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Builds the modern welcome card with enhanced design
  Widget _buildModernWelcomeCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 32,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI-Powered Code Generation',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Transform your ideas into beautiful code with CodeMuse AI',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                              .withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Enhanced feature highlights with modern design
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildModernFeatureChip(
                  context,
                  icon: Icons.flash_on_rounded,
                  label: 'Lightning Fast',
                  color: Colors.orange,
                ),
                _buildModernFeatureChip(
                  context,
                  icon: Icons.history_rounded,
                  label: 'Smart History',
                  color: Colors.blue,
                ),
                _buildModernFeatureChip(
                  context,
                  icon: Icons.highlight_alt_rounded,
                  label: 'Syntax Highlighting',
                  color: Colors.green,
                ),
                _buildModernFeatureChip(
                  context,
                  icon: Icons.palette_rounded,
                  label: 'Beautiful Themes',
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a modern feature chip with enhanced design
  Widget _buildModernFeatureChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Enhanced copy to clipboard with better feedback
  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.heavyImpact();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Code copied to clipboard!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
}
