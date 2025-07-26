import 'package:code_muse/core/services/syntax_highlight_service.dart';
import 'package:code_muse/core/services/theme_service.dart';
import 'package:code_muse/features/feature_code_review/presentation/pages/code_preview_page.dart';
import 'package:code_muse/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:code_muse/injection_container.dart' as di;
import 'package:code_muse/core/services/syntax_highlight_service.dart';
import 'package:code_muse/features/feature_homepage/presentation/provider/code_generation_provider.dart';
import 'package:flutter/services.dart';
import 'package:re_highlight/re_highlight.dart';
import 'package:re_highlight/languages/all.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// Professional code display widget with vibrant colors and beautiful design
///
/// Features:
/// - Colorful, vibrant design with beautiful gradients
/// - Animated language badges with unique colors
/// - Enhanced syntax highlighting with custom IDE-like themes
/// - Beautiful loading animations with rainbow effects
/// - Professional copy functionality with colorful feedback
/// - Line numbers and IDE-like code styling with Google Fonts
class CodeDisplayWidget extends StatefulWidget {
  const CodeDisplayWidget({super.key});

  @override
  State<CodeDisplayWidget> createState() => _CodeDisplayWidgetState();
}

class _CodeDisplayWidgetState extends State<CodeDisplayWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _rainbowController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rainbowAnimation;
  bool _isCopied = false;

  // Highlighter instance for re_highlight
  late Highlight _highlighter;
  bool _highlighterInitialized = false;

  /// Colorful language detection mapping with vibrant colors
  static const Map<String, Map<String, dynamic>> _languageConfig = {
    'dart': {
      'name': 'Dart',
      'icon': '🎯',
      'gradient': [Color(0xFF0175C2), Color(0xFF13B9FD)],
      'textColor': Colors.white,
    },
    'javascript': {
      'name': 'JavaScript',
      'icon': '⚡',
      'gradient': [Color(0xFFF7DF1E), Color(0xFFFFD700)],
      'textColor': Color(0xFF2B2B2B),
    },
    'typescript': {
      'name': 'TypeScript',
      'icon': '📘',
      'gradient': [Color(0xFF3178C6), Color(0xFF5B9BD5)],
      'textColor': Colors.white,
    },
    'python': {
      'name': 'Python',
      'icon': '🐍',
      'gradient': [Color(0xFF3776AB), Color(0xFF4B8BBE)],
      'textColor': Colors.white,
    },
    'java': {
      'name': 'Java',
      'icon': '☕',
      'gradient': [Color(0xFFED8B00), Color(0xFFFF9A00)],
      'textColor': Colors.white,
    },
    'cpp': {
      'name': 'C++',
      'icon': '⚡',
      'gradient': [Color(0xFF00599C), Color(0xFF0073B7)],
      'textColor': Colors.white,
    },
    'html': {
      'name': 'HTML',
      'icon': '🌐',
      'gradient': [Color(0xFFE34F26), Color(0xFFFF6B35)],
      'textColor': Colors.white,
    },
    'css': {
      'name': 'CSS',
      'icon': '🎨',
      'gradient': [Color(0xFF1572B6), Color(0xFF33A9DC)],
      'textColor': Colors.white,
    },
    'sql': {
      'name': 'SQL',
      'icon': '🗄️',
      'gradient': [Color(0xFF336791), Color(0xFF4F94CD)],
      'textColor': Colors.white,
    },
    'json': {
      'name': 'JSON',
      'icon': '📋',
      'gradient': [Color(0xFF292929), Color(0xFF404040)],
      'textColor': Colors.white,
    },
    'plaintext': {
      'name': 'Code',
      'icon': '📝',
      'gradient': [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
      'textColor': Colors.white,
    },
  };

  /// Improved language detection patterns (simple but more accurate)
  static const Map<String, String> _languageDetectionPatterns = {
    // HTML/XML - very distinctive
    '<!DOCTYPE html': 'html',
    '<!doctype html': 'html',
    '<html': 'html',
    '<div': 'html',
    '<span': 'html',
    '<?xml': 'xml',

    // Dart - very specific patterns
    'import \'package:': 'dart',
    'import "package:': 'dart',
    'void main()': 'dart',
    'Widget build(': 'dart',
    'extends StatelessWidget': 'dart',
    'extends StatefulWidget': 'dart',
    'MaterialApp(': 'dart',
    'Scaffold(': 'dart',

    // TypeScript - check before JavaScript
    'interface ': 'typescript',
    ': string': 'typescript',
    ': number': 'typescript',
    ': boolean': 'typescript',
    'export interface': 'typescript',
    'import type': 'typescript',

    // JavaScript/React
    'import React': 'javascript',
    'from \'react\'': 'javascript',
    'useState(': 'javascript',
    'useEffect(': 'javascript',
    'export default': 'javascript',
    'require(': 'javascript',
    'module.exports': 'javascript',
    'console.log(': 'javascript',

    // Java - very specific
    'public class ': 'java',
    'import java.': 'java',
    'public static void main(': 'java',
    'System.out.println(': 'java',

    // Python - distinctive patterns
    'def ': 'python',
    'if __name__ == "__main__":': 'python',
    'print(': 'python',
    'elif ': 'python',
    'except:': 'python',
    'from ': 'python',

    // C/C++
    '#include <': 'cpp',
    '#include "': 'cpp',
    'std::': 'cpp',
    'cout <<': 'cpp',
    'cin >>': 'cpp',
    'using namespace': 'cpp',
    'printf(': 'c',
    'scanf(': 'c',

    // C#
    'using System;': 'csharp',
    'Console.WriteLine(': 'csharp',
    'public static void Main(': 'csharp',

    // Go - very distinctive
    'package main': 'go',
    'func main()': 'go',
    'fmt.Println(': 'go',

    // Rust - distinctive
    'fn main()': 'rust',
    'let mut': 'rust',
    'println!(': 'rust',
    'use std::': 'rust',

    // PHP
    '<?php': 'php',
    'echo ': 'php',

    // Ruby
    'puts ': 'ruby',
    'require ': 'ruby',

    // Swift
    'import UIKit': 'swift',
    'import Foundation': 'swift',

    // Kotlin
    'fun main()': 'kotlin',
    'println(': 'kotlin',

    // SQL
    'SELECT ': 'sql',
    'INSERT INTO': 'sql',
    'DELETE FROM': 'sql',
    'CREATE TABLE': 'sql',
    'ALTER TABLE': 'sql',

    // CSS/SCSS
    '@import': 'scss',
    '@mixin': 'scss',
    '@include': 'scss',

    // Shell/Bash
    '#!/bin/bash': 'bash',
    '#!/bin/sh': 'shell',

    // Dockerfile
    'FROM ': 'dockerfile',
    'RUN ': 'dockerfile',
    'COPY ': 'dockerfile',
    'WORKDIR ': 'dockerfile',

    // Assembly
    '.section': 'assembly',
    '.global': 'assembly',
    'mov ': 'x86asm',
    'push ': 'x86asm',
    'pop ': 'x86asm',
  };

  @override
  void initState() {
    super.initState();

    // Initialize highlighter
    _initializeHighlighter();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rainbowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _rainbowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rainbowController, curve: Curves.linear),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _rainbowController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _rainbowController.dispose();
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

  /// Generate beautiful highlighted code using enhanced syntax highlighting service
  Widget _buildBeautifulHighlightedCode(
    String code,
    String language,
    bool isDark,
  ) {
    final syntaxService = di.sl<SyntaxHighlightingService>();

    // Add safety check for extremely large code content
    String processedCode = code;
    const maxCodeLength = 50000; // Maximum characters to prevent overflow
    const maxLines = 2000; // Maximum lines to prevent overflow

    final codeLines = code.split('\n');
    bool wasTruncated = false;

    // Truncate if code is too long
    if (code.length > maxCodeLength || codeLines.length > maxLines) {
      if (codeLines.length > maxLines) {
        processedCode = codeLines.take(maxLines).join('\n');
      } else {
        processedCode = code.substring(0, maxCodeLength);
      }
      wasTruncated = true;
    }

    return FutureBuilder(
      future: syntaxService.initialize(),
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show truncation warning if content was truncated
            if (wasTruncated)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_rounded, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Code content was truncated for performance. Full content available in IDE preview.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),

            // Syntax highlighted code
            Flexible(
              child: syntaxService.generateBeautifulHighlightedCode(
                code: processedCode,
                language: language,
                isDark: isDark,
                fontSize: 14.0,
                theme: 'auto', // Use automatic theme selection
                showLineNumbers: false,
                padding:
                    EdgeInsets.zero, // No padding as it's handled by parent
              ),
            ),
          ],
        );
      },
    );
  }

  /// Enhanced language normalization
  String _normalizeLanguageName(String language) {
    const languageMap = {
      'js': 'javascript',
      'ts': 'typescript',
      'py': 'python',
      'rb': 'ruby',
      'sh': 'bash',
      'yml': 'yaml',
      'c++': 'cpp',
      'csharp': 'cs',
      'flutter': 'dart',
      'jsx': 'javascript',
      'tsx': 'typescript',
    };

    final normalizedLang = language.toLowerCase().trim();
    return languageMap[normalizedLang] ?? normalizedLang;
  }

  /// Detects the programming language from code content using enhanced detection
  String _detectLanguage(String code) {
    final syntaxService = di.sl<SyntaxHighlightingService>();
    return syntaxService.detectLanguage(code);
  }

  /// Gets language configuration using enhanced service
  Map<String, dynamic> _getLanguageConfig(String language) {
    final syntaxService = di.sl<SyntaxHighlightingService>();
    return syntaxService.getLanguageConfig(language);
  }

  /// Splits code into lines for line numbering
  List<String> _getCodeLines(String code) {
    return code.split('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CodeGenerationProvider, ThemeService>(
      builder: (context, provider, themeService, _) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            children: [
              // Beautiful colorful header
              _buildColorfulHeader(context, provider, themeService),

              // Content area
              Expanded(child: _buildContent(context, provider, themeService)),
            ],
          ),
        );
      },
    );
  }

  /// Builds beautiful colorful header with animated language badge
  Widget _buildColorfulHeader(
    BuildContext context,
    CodeGenerationProvider provider,
    ThemeService themeService,
  ) {
    final theme = Theme.of(context);
    final hasResult = provider.hasResult;

    if (!hasResult && !provider.isLoading && !provider.hasError) {
      return const SizedBox.shrink();
    }

    final detectedLanguage =
        hasResult ? _detectLanguage(provider.generatedCode) : 'plaintext';
    final langConfig = _getLanguageConfig(detectedLanguage);

    // Provide fallback values to prevent null type errors
    final gradientColors =
        (langConfig['gradient'] as List<Color>?) ??
        [theme.colorScheme.primary, theme.colorScheme.secondary];
    final textColor = (langConfig['textColor'] as Color?) ?? Colors.white;
    final iconText = (langConfig['icon'] as String?) ?? '📄';
    final languageName = (langConfig['name'] as String?) ?? 'Unknown';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0.8),
            theme.colorScheme.secondaryContainer.withOpacity(0.6),
            theme.colorScheme.tertiaryContainer.withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Animated language badge with beautiful gradients
          Flexible(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * _fadeAnimation.value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              gradientColors.isNotEmpty
                                  ? gradientColors[0].withOpacity(0.3)
                                  : theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(iconText, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            languageName,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 8),

          // Beautiful copy button with gradient and animation
          if (hasResult)
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.9 + (0.1 * _fadeAnimation.value),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient:
                          _isCopied
                              ? LinearGradient(
                                colors: [
                                  Colors.green.shade400,
                                  Colors.green.shade600,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                              : LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primary.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (_isCopied
                                  ? Colors.green
                                  : theme.colorScheme.primary)
                              .withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _copyToClipboard(provider.generatedCode),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isCopied
                                    ? Icons.check_circle
                                    : Icons.copy_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isCopied ? 'Copied!' : 'Copy',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          const SizedBox(width: 8),

          // Beautiful "View Full Preview" button with navigation
          if (hasResult)
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.9 + (0.1 * _fadeAnimation.value),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade400,
                          Colors.purple.shade600,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _navigateToFullPreview(context, provider),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.fullscreen,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Full View',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  /// Builds the main content area
  Widget _buildContent(
    BuildContext context,
    CodeGenerationProvider provider,
    ThemeService themeService,
  ) {
    if (provider.isLoading) {
      return _buildRainbowLoadingState(context);
    }

    if (provider.hasError) {
      return _buildColorfulErrorState(context, provider);
    }

    if (!provider.hasResult) {
      return _buildBeautifulEmptyState(context);
    }

    return _buildIDELikeCodeView(context, provider, themeService);
  }

  /// Builds rainbow loading state with beautiful animations
  Widget _buildRainbowLoadingState(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rainbow animated loading indicator
          AnimatedBuilder(
            animation: _rainbowAnimation,
            builder: (context, child) {
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      Colors.green,
                      Colors.blue,
                      Colors.indigo,
                      Colors.purple,
                      Colors.red,
                    ],
                    stops: const [0.0, 0.16, 0.33, 0.5, 0.66, 0.83, 1.0, 1.0],
                    transform: GradientRotation(
                      _rainbowAnimation.value * 2 * 3.14159,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.surface,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: theme.colorScheme.primary,
                      size: 30,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Animated text with gradient
          ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [
                    Colors.purple,
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                  ],
                ).createShader(bounds),
            child: Text(
              'Creating Magic...',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'DeepSeek AI is crafting your perfect solution',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Animated progress dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _rainbowAnimation,
                builder: (context, child) {
                  final delay = index * 0.3;
                  final animValue = (_rainbowAnimation.value + delay) % 1.0;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.lerp(
                        Colors.grey.shade300,
                        Colors.purple,
                        animValue,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Builds colorful error state
  Widget _buildColorfulErrorState(
    BuildContext context,
    CodeGenerationProvider provider,
  ) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade400, Colors.red.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 24),

          ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [Colors.red.shade400, Colors.red.shade600],
                ).createShader(bounds),
            child: Text(
              'Oops! Something went wrong',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              provider.errorMessage ?? 'Unknown error occurred',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.red.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => provider.clearResult(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds beautiful empty state
  Widget _buildBeautifulEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade300,
                  Colors.blue.shade400,
                  Colors.green.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 48,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 24),

          ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [Colors.purple, Colors.blue, Colors.green],
                ).createShader(bounds),
            child: Text(
              'Ready to Create Magic?',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Describe what you want to build and watch the magic happen',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Feature chips with colorful gradients
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildColorfulFeatureChip(context, '⚡', 'Lightning Fast', [
                Colors.orange,
                Colors.red,
              ]),
              _buildColorfulFeatureChip(context, '🎨', 'Beautiful Code', [
                Colors.purple,
                Colors.pink,
              ]),
              _buildColorfulFeatureChip(context, '🚀', 'AI Powered', [
                Colors.blue,
                Colors.cyan,
              ]),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds colorful feature chip
  Widget _buildColorfulFeatureChip(
    BuildContext context,
    String icon,
    String label,
    List<Color> gradientColors,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds IDE-like code view with vibrant syntax highlighting and line numbers
  Widget _buildIDELikeCodeView(
    BuildContext context,
    CodeGenerationProvider provider,
    ThemeService themeService,
  ) {
    final theme = Theme.of(context);
    final detectedLanguage = _detectLanguage(provider.generatedCode);

    // Trigger animations when code appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      _slideController.forward();
    });

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors:
                  themeService.isDarkMode
                      ? [const Color(0xFF1e1e1e), const Color(0xFF252525)]
                      : [const Color(0xFFfefefe), const Color(0xFFf8f9fa)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Provide proper constraints to prevent overflow
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight:
                        constraints.maxHeight > 0
                            ? constraints.maxHeight -
                                32 // Account for margin
                            : double.infinity,
                    maxWidth:
                        constraints.maxWidth > 0
                            ? constraints.maxWidth -
                                32 // Account for margin
                            : double.infinity,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 0,
                        maxWidth:
                            constraints.maxWidth > 0
                                ? constraints.maxWidth -
                                    64 // Account for padding
                                : double.infinity,
                      ),
                      child: _buildBeautifulHighlightedCode(
                        provider.generatedCode,
                        detectedLanguage,
                        themeService.isDarkMode,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Copies code to clipboard with beautiful feedback
  Future<void> _copyToClipboard(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    HapticFeedback.mediumImpact();

    setState(() {
      _isCopied = true;
    });

    // Reset copy state after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  /// Navigate to full code preview page
  void _navigateToFullPreview(
    BuildContext context,
    CodeGenerationProvider provider,
  ) {
    if (!provider.hasResult) return;

    HapticFeedback.lightImpact();

    final detectedLanguage = _detectLanguage(provider.generatedCode);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => IdeCodePreviewPage(
              code: provider.generatedCode,
              language: detectedLanguage,
              prompt:
                  provider.currentPrompt.isNotEmpty
                      ? provider.currentPrompt
                      : 'Generated Code',
              result: provider.lastResult,
            ),
      ),
    );
  }
}
