import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re_highlight/languages/all.dart';
import 'package:re_highlight/re_highlight.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../infrastructure/services/theme_service.dart';
import '../../infrastructure/services/syntax_highlighting_service.dart';
import '../../core/di/injection_container.dart' as di;

/// A reusable code preview widget with comprehensive features
///
/// Features:
/// - Multi-language syntax highlighting (190+ languages via re_highlight)
/// - Dark/light theme support
/// - Optional line numbers
/// - Copy to clipboard functionality
/// - Language labels with color coding
/// - Responsive design for mobile/tablet
/// - Scrollable content with proper wrapping
/// - Rounded corners and shadows
/// - Monospaced font for better readability
class CodePreviewWidget extends StatefulWidget {
  /// The code content to display
  final String code;

  /// The programming language for syntax highlighting
  final String language;

  /// Whether to show line numbers (default: true)
  final bool showLineNumbers;

  /// Whether to show the copy button (default: true)
  final bool showCopyButton;

  /// Whether to show the language label (default: true)
  final bool showLanguageLabel;

  /// Custom height for the widget (default: adaptive)
  final double? height;

  /// Custom width for the widget (default: full width)
  final double? width;

  /// Whether to force dark theme regardless of system theme
  final bool? forceDarkTheme;

  /// Font size for the code (default: 14.0)
  final double fontSize;

  /// Padding inside the code container
  final EdgeInsets padding;

  /// Border radius for the container
  final double borderRadius;

  /// Whether to show a shadow around the container
  final bool showShadow;

  /// Whether to highlight important parts of code (functions, classes, etc.)
  final bool highlightImportantParts;

  const CodePreviewWidget({
    super.key,
    required this.code,
    required this.language,
    this.showLineNumbers = false,
    this.showCopyButton = true,
    this.showLanguageLabel = true,
    this.height,
    this.width,
    this.forceDarkTheme,
    this.fontSize = 14.0,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 12.0,
    this.showShadow = true,
    this.highlightImportantParts = true,
  });

  @override
  State<CodePreviewWidget> createState() => _CodePreviewWidgetState();
}

class _CodePreviewWidgetState extends State<CodePreviewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isCopied = false;

  // Add scroll controllers for synchronized scrolling
  late ScrollController _verticalScrollController;
  late ScrollController _horizontalScrollController;
  late ScrollController _lineNumberScrollController;

  // Highlighter instance
  late Highlight _highlighter;
  bool _highlighterInitialized = false;

  // Theme state variables
  Map<String, TextStyle>? _lightTheme;
  Map<String, TextStyle>? _darkTheme;
  bool _themesLoaded = false;

  /// Enhanced language configuration with 100+ programming languages
  static const Map<String, Map<String, dynamic>> _languageConfig = {
    // Popular languages
    'dart': {'name': 'Dart', 'color': Color(0xFF0175C2), 'icon': '🎯'},
    'javascript': {
      'name': 'JavaScript',
      'color': Color(0xFFF7DF1E),
      'icon': '⚡',
    },
    'typescript': {
      'name': 'TypeScript',
      'color': Color(0xFF3178C6),
      'icon': '📘',
    },
    'python': {'name': 'Python', 'color': Color(0xFF3776AB), 'icon': '🐍'},
    'java': {'name': 'Java', 'color': Color(0xFFED8B00), 'icon': '☕'},
    'cpp': {'name': 'C++', 'color': Color(0xFF00599C), 'icon': '⚡'},
    'c': {'name': 'C', 'color': Color(0xFF00599C), 'icon': '🔧'},
    'csharp': {'name': 'C#', 'color': Color(0xFF239120), 'icon': '🔷'},
    'cs': {'name': 'C#', 'color': Color(0xFF239120), 'icon': '🔷'},
    'go': {'name': 'Go', 'color': Color(0xFF00ADD8), 'icon': '🔥'},
    'golang': {'name': 'Go', 'color': Color(0xFF00ADD8), 'icon': '🔥'},
    'rust': {'name': 'Rust', 'color': Color(0xFFCE422B), 'icon': '🦀'},
    'swift': {'name': 'Swift', 'color': Color(0xFFFA7343), 'icon': '🍎'},
    'kotlin': {'name': 'Kotlin', 'color': Color(0xFF7F52FF), 'icon': '💎'},
    'php': {'name': 'PHP', 'color': Color(0xFF777BB4), 'icon': '🐘'},
    'ruby': {'name': 'Ruby', 'color': Color(0xFFCC342D), 'icon': '💎'},
    'scala': {'name': 'Scala', 'color': Color(0xFFDC322F), 'icon': '🎭'},
    'perl': {'name': 'Perl', 'color': Color(0xFF39457E), 'icon': '🐪'},
    'r': {'name': 'R', 'color': Color(0xFF276DC3), 'icon': '📊'},
    'matlab': {'name': 'MATLAB', 'color': Color(0xFF0076A8), 'icon': '📊'},
    'julia': {'name': 'Julia', 'color': Color(0xFF9558B2), 'icon': '🔬'},

    // Web technologies
    'html': {'name': 'HTML', 'color': Color(0xFFE34F26), 'icon': '🌐'},
    'xml': {'name': 'XML', 'color': Color(0xFF0060AC), 'icon': '📄'},
    'css': {'name': 'CSS', 'color': Color(0xFF1572B6), 'icon': '🎨'},
    'scss': {'name': 'SCSS', 'color': Color(0xFFCF649A), 'icon': '🎨'},
    'sass': {'name': 'Sass', 'color': Color(0xFFCF649A), 'icon': '🎨'},
    'less': {'name': 'Less', 'color': Color(0xFF1D365D), 'icon': '🎨'},
    'vue': {'name': 'Vue.js', 'color': Color(0xFF4FC08D), 'icon': '💚'},
    'svelte': {'name': 'Svelte', 'color': Color(0xFFFF3E00), 'icon': '🧡'},
    'react': {'name': 'React', 'color': Color(0xFF61DAFB), 'icon': '⚛️'},
    'angular': {'name': 'Angular', 'color': Color(0xFFDD0031), 'icon': '🅰️'},

    // Database & Query languages
    'sql': {'name': 'SQL', 'color': Color(0xFF336791), 'icon': '🗄️'},
    'mysql': {'name': 'MySQL', 'color': Color(0xFF4479A1), 'icon': '🐬'},
    'postgresql': {
      'name': 'PostgreSQL',
      'color': Color(0xFF336791),
      'icon': '🐘',
    },
    'sqlite': {'name': 'SQLite', 'color': Color(0xFF003B57), 'icon': '📊'},
    'mongodb': {'name': 'MongoDB', 'color': Color(0xFF47A248), 'icon': '🍃'},

    // Markup & Config languages
    'json': {'name': 'JSON', 'color': Color(0xFF000000), 'icon': '📄'},
    'yaml': {'name': 'YAML', 'color': Color(0xFF000000), 'icon': '📄'},
    'yml': {'name': 'YAML', 'color': Color(0xFF000000), 'icon': '📄'},
    'toml': {'name': 'TOML', 'color': Color(0xFF9C4221), 'icon': '📄'},
    'ini': {'name': 'INI', 'color': Color(0xFF427819), 'icon': '⚙️'},
    'properties': {
      'name': 'Properties',
      'color': Color(0xFF427819),
      'icon': '⚙️',
    },
    'markdown': {'name': 'Markdown', 'color': Color(0xFF000000), 'icon': '📝'},
    'md': {'name': 'Markdown', 'color': Color(0xFF000000), 'icon': '📝'},
    'dockerfile': {
      'name': 'Dockerfile',
      'color': Color(0xFF2496ED),
      'icon': '🐳',
    },

    // Shell & Scripts
    'bash': {'name': 'Bash', 'color': Color(0xFF4EAA25), 'icon': '⚡'},
    'sh': {'name': 'Shell', 'color': Color(0xFF4EAA25), 'icon': '🐚'},
    'shell': {'name': 'Shell', 'color': Color(0xFF4EAA25), 'icon': '🐚'},
    'zsh': {'name': 'Zsh', 'color': Color(0xFF4EAA25), 'icon': '⚡'},
    'fish': {'name': 'Fish', 'color': Color(0xFF4EAA25), 'icon': '🐠'},
    'powershell': {
      'name': 'PowerShell',
      'color': Color(0xFF012456),
      'icon': '💻',
    },
    'cmd': {'name': 'Batch', 'color': Color(0xFF00599C), 'icon': '⚙️'},
    'batch': {'name': 'Batch', 'color': Color(0xFF00599C), 'icon': '⚙️'},
    'bat': {'name': 'Batch', 'color': Color(0xFF00599C), 'icon': '⚙️'},
    'lua': {'name': 'Lua', 'color': Color(0xFF2C2D72), 'icon': '🌙'},

    // Functional languages
    'haskell': {'name': 'Haskell', 'color': Color(0xFF5E5086), 'icon': '🎭'},
    'elixir': {'name': 'Elixir', 'color': Color(0xFF4B275F), 'icon': '💜'},
    'erlang': {'name': 'Erlang', 'color': Color(0xFFB83998), 'icon': '📞'},
    'clojure': {'name': 'Clojure', 'color': Color(0xFF5881D8), 'icon': '🔵'},
    'lisp': {'name': 'Lisp', 'color': Color(0xFF3FB68B), 'icon': '🔗'},
    'scheme': {'name': 'Scheme', 'color': Color(0xFF1E4AE9), 'icon': '🔗'},
    'ocaml': {'name': 'OCaml', 'color': Color(0xFFEC6813), 'icon': '🐫'},
    'fsharp': {'name': 'F#', 'color': Color(0xFF378BBA), 'icon': '🔷'},

    // System & Low-level
    'assembly': {'name': 'Assembly', 'color': Color(0xFF6E4C13), 'icon': '⚙️'},
    'asm': {'name': 'Assembly', 'color': Color(0xFF6E4C13), 'icon': '⚙️'},
    'x86asm': {
      'name': 'x86 Assembly',
      'color': Color(0xFF6E4C13),
      'icon': '⚙️',
    },
    'armasm': {
      'name': 'ARM Assembly',
      'color': Color(0xFF6E4C13),
      'icon': '⚙️',
    },
    'llvm': {'name': 'LLVM', 'color': Color(0xFF262D3A), 'icon': '🔧'},

    // Web Assembly
    'wasm': {'name': 'WebAssembly', 'color': Color(0xFF654FF0), 'icon': '🕸️'},

    // Build & Config
    'cmake': {'name': 'CMake', 'color': Color(0xFF064F8C), 'icon': '🔨'},
    'makefile': {'name': 'Makefile', 'color': Color(0xFF427819), 'icon': '🔨'},
    'make': {'name': 'Makefile', 'color': Color(0xFF427819), 'icon': '🔨'},
    'gradle': {'name': 'Gradle', 'color': Color(0xFF02303A), 'icon': '🔨'},
    'maven': {'name': 'Maven', 'color': Color(0xFFC71A36), 'icon': '📦'},
    'npm': {'name': 'NPM', 'color': Color(0xFFCB3837), 'icon': '📦'},

    // Game Development
    'glsl': {'name': 'GLSL', 'color': Color(0xFF5686A5), 'icon': '🎮'},
    'hlsl': {'name': 'HLSL', 'color': Color(0xFF5686A5), 'icon': '🎮'},

    // Mobile Development
    'objectivec': {
      'name': 'Objective-C',
      'color': Color(0xFF438EFF),
      'icon': '🍎',
    },
    'objc': {'name': 'Objective-C', 'color': Color(0xFF438EFF), 'icon': '🍎'},

    // Legacy & Specialized
    'fortran': {'name': 'Fortran', 'color': Color(0xFF734F96), 'icon': '🔬'},
    'cobol': {'name': 'COBOL', 'color': Color(0xFF006BB6), 'icon': '🏦'},
    'pascal': {'name': 'Pascal', 'color': Color(0xFF004482), 'icon': '🔺'},
    'delphi': {'name': 'Delphi', 'color': Color(0xFFEE1F35), 'icon': '🔺'},
    'vbnet': {'name': 'VB.NET', 'color': Color(0xFF945DB7), 'icon': '🔷'},
    'vb': {'name': 'Visual Basic', 'color': Color(0xFF945DB7), 'icon': '🔷'},

    // Modern systems languages
    'zig': {'name': 'Zig', 'color': Color(0xFFF7A41D), 'icon': '⚡'},
    'nim': {'name': 'Nim', 'color': Color(0xFFFFE953), 'icon': '👑'},
    'crystal': {'name': 'Crystal', 'color': Color(0xFF000000), 'icon': '💎'},
    'dlang': {'name': 'D', 'color': Color(0xFFBA595E), 'icon': '🔶'},
    'd': {'name': 'D', 'color': Color(0xFFBA595E), 'icon': '🔶'},

    // Template engines
    'handlebars': {
      'name': 'Handlebars',
      'color': Color(0xFFFC7428),
      'icon': '🔧',
    },
    'mustache': {'name': 'Mustache', 'color': Color(0xFF724B0C), 'icon': '👨'},
    'jinja2': {'name': 'Jinja2', 'color': Color(0xFFB41717), 'icon': '🎭'},
    'twig': {'name': 'Twig', 'color': Color(0xFFBACB2F), 'icon': '🌿'},

    // Default fallback
    'plaintext': {'name': 'Text', 'color': Color(0xFF666666), 'icon': '📄'},
    'text': {'name': 'Text', 'color': Color(0xFF666666), 'icon': '📄'},
    'txt': {'name': 'Text', 'color': Color(0xFF666666), 'icon': '📄'},
    'unknown': {'name': 'Code', 'color': Color(0xFF666666), 'icon': '📄'},
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialize scroll controllers
    _verticalScrollController = ScrollController();
    _horizontalScrollController = ScrollController();
    _lineNumberScrollController = ScrollController();

    // Sync line number scrolling with code content
    _verticalScrollController.addListener(_syncLineNumberScroll);

    // Initialize highlighter
    _initializeHighlighter();

    // Load themes from settings
    _loadThemes();

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    _lineNumberScrollController.dispose();
    super.dispose();
  }

  /// Initialize the re_highlight highlighter with all supported languages
  void _initializeHighlighter() {
    try {
      _highlighter = Highlight();
      _highlighter.registerLanguages(builtinAllLanguages);
      _highlighterInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize highlighter: $e');
      _highlighterInitialized = false;
    }
  }

  /// Synchronize line number scrolling with code content
  void _syncLineNumberScroll() {
    if (_lineNumberScrollController.hasClients &&
        _verticalScrollController.hasClients) {
      _lineNumberScrollController.jumpTo(_verticalScrollController.offset);
    }
  }

  /// Get the display name for a language
  String _getLanguageDisplayName() {
    return _languageConfig[widget.language.toLowerCase()]?['name'] ??
        widget.language.toUpperCase();
  }

  /// Get the color for a language
  Color _getLanguageColor() {
    return _languageConfig[widget.language.toLowerCase()]?['color'] ??
        const Color(0xFF666666);
  }

  /// Get the icon for a language
  String _getLanguageIcon() {
    return _languageConfig[widget.language.toLowerCase()]?['icon'] ?? '📄';
  }

  /// Get the lines of code for line numbering
  List<String> _getCodeLines() {
    return widget.code.split('\n');
  }

  /// Load themes from SyntaxHighlightingService with enhanced settings support
  Future<void> _loadThemes() async {
    try {
      final syntaxService = di.get<SyntaxHighlightingService>();

      final selectedTheme = syntaxService.selectedTheme;

      debugPrint('CodePreviewWidget loading theme: $selectedTheme');

      setState(() {
        _lightTheme = syntaxService.getBeautifulTheme(selectedTheme, false);
        _darkTheme = syntaxService.getBeautifulTheme(selectedTheme, true);
        _themesLoaded = true;
      });

      debugPrint('Themes loaded successfully for CodePreviewWidget');
    } catch (e) {
      debugPrint('Failed to load themes in CodePreviewWidget: $e');

      // Set fallback themes with enhanced error handling
      final syntaxService = di.get<SyntaxHighlightingService>();
      try {
        setState(() {
          _lightTheme = syntaxService.getBeautifulTheme(
            'github_enhanced',
            false,
          );
          _darkTheme = syntaxService.getBeautifulTheme('github_enhanced', true);
          _themesLoaded = true;
        });
        debugPrint('Fallback themes loaded for CodePreviewWidget');
      } catch (fallbackError) {
        debugPrint('Even fallback themes failed: $fallbackError');
        setState(() {
          _themesLoaded = true; // Mark as loaded to prevent infinite loading
        });
      }
    }
  }

  /// Refresh themes when settings change (called externally)
  Future<void> refreshThemes() async {
    await _loadThemes();
  }

  @override
  void didUpdateWidget(CodePreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reload themes if the widget properties that might affect theming changed
    if (oldWidget.highlightImportantParts != widget.highlightImportantParts ||
        oldWidget.language != widget.language) {
      _loadThemes();
    }
  }

  /// Get the appropriate theme for highlighting with beautiful modern themes
  Map<String, TextStyle> _getThemeForHighlighting(bool isDark) {
    if (!_themesLoaded) {
      // Return a basic fallback theme while loading
      final syntaxService = di.get<SyntaxHighlightingService>();
      return syntaxService.getBeautifulTheme('github_enhanced', isDark);
    }

    return isDark ? _darkTheme! : _lightTheme!;
  }

  /// Get the background color from the theme
  Color _getThemeBackgroundColor(bool isDark) {
    final theme = _getThemeForHighlighting(isDark);
    final rootStyle = theme['root'];
    if (rootStyle?.backgroundColor != null) {
      return rootStyle!.backgroundColor!;
    }
    // Fallback colors
    return isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
  }

  /// Enhanced language normalization with 100+ language support
  String _normalizeLanguageName(String language) {
    // Comprehensive language aliases mapping
    const languageMap = {
      // Common aliases
      'js': 'javascript',
      'ts': 'typescript',
      'py': 'python',
      'rb': 'ruby',
      'sh': 'bash',
      'dockerfile': 'docker',
      'yml': 'yaml',
      'c++': 'cpp',
      'csharp': 'cs',

      // Flutter-specific
      'flutter': 'dart',
      'dart-flutter': 'dart',

      // Web technologies
      'htm': 'html',
      'xhtml': 'xml',
      'jsx': 'javascript',
      'tsx': 'typescript',
      'vue': 'vue',
      'svelte': 'svelte',

      // Database
      'postgres': 'postgresql',
      'psql': 'postgresql',
      'sqlite3': 'sql',

      // Shell scripts
      'zsh': 'bash',
      'fish': 'bash',
      'cmd': 'batch',
      'bat': 'batch',
      'ps1': 'powershell',

      // Assembly
      'asm': 'x86asm',
      'nasm': 'x86asm',
      'masm': 'x86asm',

      // Build systems
      'makefile': 'make',
      'cmake': 'cmake',
      'gradle': 'groovy',

      // Configuration files
      'config': 'ini',
      'conf': 'apache',
      'nginx': 'nginx',
      'apache': 'apache',

      // Text formats
      'text': 'plaintext',
      'txt': 'plaintext',
      'log': 'accesslog',
      'md': 'markdown',

      // Programming language aliases
      'golang': 'go',
      'objective-c': 'objectivec',
      'objc': 'objectivec',
      'obj-c': 'objectivec',
      'f#': 'fsharp',
      'c#': 'csharp',
      'vb.net': 'vbnet',
    };

    final normalizedLang = language.toLowerCase().trim();
    return languageMap[normalizedLang] ?? normalizedLang;
  }

  /// Copy code to clipboard with visual feedback
  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    HapticFeedback.lightImpact();

    setState(() {
      _isCopied = true;
    });

    // Reset copy state after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });

    // Show snackbar feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                'Code copied to clipboard!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w400),
              ),
            ],
          ),
          backgroundColor: _getLanguageColor(),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  /// Calculate the width needed for line numbers
  double _calculateLineNumberWidth(int numberOfLines, double fontSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: numberOfLines.toString(),
        style: GoogleFonts.jetBrainsMono(
          fontSize: fontSize - 1,
          height: 1.4,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width + 16; // Add some padding
  }

  /// Generate highlighted TextSpan using re_highlight
  TextSpan _generateHighlightedTextSpan(bool isDark) {
    if (!_highlighterInitialized) {
      // Fallback to plain text if highlighter failed to initialize
      return TextSpan(
        text: widget.code,
        style: GoogleFonts.jetBrainsMono(
          fontSize: widget.fontSize,
          height: 1.4,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : Colors.black,
        ),
      );
    }

    try {
      final normalizedLanguage = _normalizeLanguageName(widget.language);
      final theme = _getThemeForHighlighting(isDark);

      // Highlight the code using the correct API - fix nullability issue
      final result = _highlighter.highlight(
        code: widget.code,
        language:
            normalizedLanguage.isNotEmpty ? normalizedLanguage : 'plaintext',
      );

      // Create TextSpanRenderer to convert result to TextSpan
      final defaultStyle = GoogleFonts.jetBrainsMono(
        fontSize: widget.fontSize,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: isDark ? Colors.white : Colors.black,
      );

      final renderer = TextSpanRenderer(defaultStyle, theme);
      result.render(renderer);

      return renderer.span ?? TextSpan(text: widget.code, style: defaultStyle);
    } catch (e) {
      debugPrint('Highlighting failed for language ${widget.language}: $e');
      // Fallback to plain text
      return TextSpan(
        text: widget.code,
        style: GoogleFonts.jetBrainsMono(
          fontSize: widget.fontSize,
          height: 1.4,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : Colors.black,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final isDark = widget.forceDarkTheme ?? themeService.isDarkMode;
        final codeLines = _getCodeLines();
        final languageColor = _getLanguageColor();

        // Responsive design considerations
        final screenWidth = MediaQuery.of(context).size.width;
        final isCompact = screenWidth < 600;

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow:
                  widget.showShadow
                      ? [
                        BoxShadow(
                          color:
                              isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with language label and copy button
                  if (widget.showLanguageLabel || widget.showCopyButton)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isCompact ? 12 : 16,
                        vertical: isCompact ? 8 : 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? const Color(0xFF2D2D2D)
                                : const Color(0xFFF6F8FA),
                        border: Border(
                          bottom: BorderSide(
                            color:
                                isDark ? Colors.grey[700]! : Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Language label
                          if (widget.showLanguageLabel)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isCompact ? 8 : 12,
                                vertical: isCompact ? 4 : 6,
                              ),
                              decoration: BoxDecoration(
                                color: languageColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: languageColor.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _getLanguageIcon(),
                                    style: TextStyle(
                                      fontSize: isCompact ? 12 : 14,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _getLanguageDisplayName(),
                                    style: GoogleFonts.inter(
                                      fontSize: isCompact ? 11 : 12,
                                      fontWeight: FontWeight.w500,
                                      color: languageColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Copy button
                          if (widget.showCopyButton)
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _copyToClipboard,
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isCompact ? 8 : 12,
                                    vertical: isCompact ? 6 : 8,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _isCopied ? Icons.check : Icons.copy,
                                        size: isCompact ? 14 : 16,
                                        color:
                                            isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _isCopied ? 'Copied!' : 'Copy',
                                        style: GoogleFonts.inter(
                                          fontSize: isCompact ? 11 : 12,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              isDark
                                                  ? Colors.grey[400]
                                                  : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                  // Code content area with proper constraints
                  Expanded(
                    child: Container(
                      color: _getThemeBackgroundColor(isDark),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Scrollable line numbers
                          if (widget.showLineNumbers)
                            Container(
                              width: _calculateLineNumberWidth(
                                codeLines.length,
                                widget.fontSize,
                              ),
                              color: _getThemeBackgroundColor(isDark),
                              child: SingleChildScrollView(
                                controller: _lineNumberScrollController,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(
                                  top: widget.padding.top,
                                  left: isCompact ? 8 : 12,
                                  right: isCompact ? 8 : 12,
                                  bottom: widget.padding.bottom,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children:
                                      codeLines.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        return Container(
                                          height: widget.fontSize * 1.4,
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${index + 1}',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: widget.fontSize - 1,
                                              height: 1.4,
                                              color:
                                                  isDark
                                                      ? Colors.grey[600]
                                                      : Colors.grey[500],
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),

                          // Vertical separator
                          if (widget.showLineNumbers)
                            Container(
                              width: 1,
                              color:
                                  isDark ? Colors.grey[700] : Colors.grey[300],
                            ),

                          // Code content with enhanced syntax highlighting using re_highlight
                          Expanded(
                            child: Scrollbar(
                              controller: _verticalScrollController,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                controller: _horizontalScrollController,
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  controller: _verticalScrollController,
                                  padding: widget.padding,
                                  child: RichText(
                                    text: _generateHighlightedTextSpan(isDark),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
