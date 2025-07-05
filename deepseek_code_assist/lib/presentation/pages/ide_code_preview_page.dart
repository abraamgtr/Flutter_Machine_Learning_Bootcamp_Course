import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/code_generation.dart';
import '../../infrastructure/services/theme_service.dart';
import '../widgets/code_preview_widget.dart';

/// IDE-like Code Preview Page for Generated Code
///
/// This page provides a beautiful, full-screen IDE-like interface for viewing
/// generated code with features similar to ChatGPT or GitHub's code rendering:
/// - Multi-language syntax highlighting
/// - Dark/light theme toggling
/// - Line numbers and language detection
/// - Copy to clipboard functionality
/// - Responsive design for mobile and tablet
/// - Beautiful animations and transitions
/// - Enhanced toolbar with quick actions
class IdeCodePreviewPage extends StatefulWidget {
  /// The generated code to display
  final String code;

  /// The programming language for syntax highlighting
  final String language;

  /// The original prompt that generated this code
  final String prompt;

  /// Optional generation result with metadata
  final CodeGenerationResult? result;

  const IdeCodePreviewPage({
    super.key,
    required this.code,
    required this.language,
    required this.prompt,
    this.result,
  });

  @override
  State<IdeCodePreviewPage> createState() => _IdeCodePreviewPageState();
}

class _IdeCodePreviewPageState extends State<IdeCodePreviewPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _showLineNumbers = false;
  bool _wordWrap = false;
  bool _highlightImportantParts = true;
  double _fontSize = 14.0;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Start animations
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

  /// Copy the entire code to clipboard with enhanced feedback
  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    HapticFeedback.lightImpact();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text(
                'Code copied to clipboard!',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green[600],
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

  /// Share the code with other apps
  Future<void> _shareCode() async {
    final shareText = '''
Prompt: ${widget.prompt}

Generated Code (${widget.language.toUpperCase()}):
${widget.code}

Generated with DeepSeek Code Assistant
''';

    await Clipboard.setData(ClipboardData(text: shareText));
    HapticFeedback.lightImpact();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.share, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text(
                'Code and prompt copied for sharing!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: Colors.blue[600],
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

  /// Show settings bottom sheet
  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSettingsSheet(),
    );
  }

  /// Build the settings bottom sheet
  Widget _buildSettingsSheet() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Display Settings',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Line Numbers Toggle
          SwitchListTile(
            title: Text(
              'Show Line Numbers',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Display line numbers in the code editor',
              style: GoogleFonts.inter(color: Colors.grey[600]),
            ),
            value: _showLineNumbers,
            onChanged: (value) {
              setState(() {
                _showLineNumbers = value;
              });
              Navigator.pop(context);
            },
          ),

          // Word Wrap Toggle
          SwitchListTile(
            title: Text(
              'Word Wrap',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Wrap long lines of code',
              style: GoogleFonts.inter(color: Colors.grey[600]),
            ),
            value: _wordWrap,
            onChanged: (value) {
              setState(() {
                _wordWrap = value;
              });
              Navigator.pop(context);
            },
          ),

          // Highlight Important Parts Toggle
          SwitchListTile(
            title: Text(
              'Highlight Important Parts',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Emphasize functions, classes, and key code elements',
              style: GoogleFonts.inter(color: Colors.grey[600]),
            ),
            value: _highlightImportantParts,
            onChanged: (value) {
              setState(() {
                _highlightImportantParts = value;
              });
              Navigator.pop(context);
            },
          ),

          // Font Size Slider
          ListTile(
            title: Text(
              'Font Size: ${_fontSize.toInt()}px',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            subtitle: Slider(
              value: _fontSize,
              min: 10.0,
              max: 20.0,
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  _fontSize = value;
                });
              },
              onChangeEnd: (value) {
                Navigator.pop(context);
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Build the enhanced app bar
  PreferredSizeWidget _buildEnhancedAppBar(ThemeService themeService) {
    return AppBar(
      title: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Code Preview',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            if (widget.result != null)
              Text(
                '${widget.result!.tokenUsage.total} tokens • ${widget.result!.model}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
          ],
        ),
      ),
      elevation: 0,
      scrolledUnderElevation: 4,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      actions: [
        // Settings
        AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _fadeAnimation.value,
              child: IconButton(
                onPressed: _showSettings,
                icon: const Icon(Icons.tune),
                tooltip: 'Display Settings',
                style: IconButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ),
            );
          },
        ),

        // Share
        AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _fadeAnimation.value,
              child: IconButton(
                onPressed: _shareCode,
                icon: const Icon(Icons.share),
                tooltip: 'Share Code',
                style: IconButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ),
            );
          },
        ),

        // Copy
        AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _fadeAnimation.value,
              child: IconButton(
                onPressed: _copyCode,
                icon: const Icon(Icons.copy),
                tooltip: 'Copy Code',
                style: IconButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ),
            );
          },
        ),

        // Theme Toggle
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
                tooltip: 'Toggle Theme',
                style: IconButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ),
            );
          },
        ),

        const SizedBox(width: 8),
      ],
    );
  }

  /// Build the prompt card
  Widget _buildPromptCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Original Prompt',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.prompt,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: _buildEnhancedAppBar(themeService),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Prompt Card
                  _buildPromptCard(),

                  // Code Preview
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: CodePreviewWidget(
                        code: widget.code,
                        language: widget.language,
                        showLineNumbers: _showLineNumbers,
                        showCopyButton: true,
                        showLanguageLabel: true,
                        fontSize: _fontSize,
                        borderRadius: 12,
                        showShadow: true,
                        padding: const EdgeInsets.all(16),
                        highlightImportantParts: _highlightImportantParts,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
