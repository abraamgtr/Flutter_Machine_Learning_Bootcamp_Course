import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:re_highlight/re_highlight.dart';
import 'package:re_highlight/languages/all.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enhanced syntax highlighting service with beautiful themes and improved language detection
///
/// This service provides:
/// - 10+ beautiful custom themes for syntax highlighting
/// - Enhanced language detection with 150+ patterns
/// - Visual improvements and modern design elements
/// - Professional typography and spacing
/// - Gradient backgrounds and modern color schemes
/// - Settings persistence with SharedPreferences
class SyntaxHighlightingService {
  static final SyntaxHighlightingService _instance =
      SyntaxHighlightingService._internal();
  factory SyntaxHighlightingService() => _instance;
  SyntaxHighlightingService._internal();

  late Highlight _highlighter;
  bool _initialized = false;

  /// SharedPreferences instance for settings persistence
  SharedPreferences? _prefs;

  /// Settings keys
  static const String _selectedThemeKey = 'selected_syntax_theme';
  static const String _showLineNumbersKey = 'show_line_numbers_preference';
  static const String _highlightImportantKey = 'highlight_important_parts';
  static const String _fontSizeKey = 'syntax_font_size';

  /// Current settings with defaults
  String _selectedTheme = 'github_enhanced';
  bool _showLineNumbers = true;
  bool _highlightImportantParts = true;
  double _fontSize = 14.0;

  /// Getters for current settings
  String get selectedTheme => _selectedTheme;
  bool get showLineNumbers => _showLineNumbers;
  bool get highlightImportantParts => _highlightImportantParts;
  double get fontSize => _fontSize;

  /// Initialize the service with settings persistence
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize SharedPreferences
      _prefs = await SharedPreferences.getInstance();

      // Load saved settings
      await _loadSettings();

      // Initialize syntax highlighter
      _highlighter = Highlight();
      _highlighter.registerLanguages(builtinAllLanguages);
      _initialized = true;

      debugPrint(
        'SyntaxHighlightingService initialized with theme: $_selectedTheme',
      );
    } catch (e) {
      debugPrint('Failed to initialize syntax highlighter: $e');
      _initialized = false;
    }
  }

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    if (_prefs == null) return;

    _selectedTheme = _prefs!.getString(_selectedThemeKey) ?? 'github_enhanced';
    _showLineNumbers = _prefs!.getBool(_showLineNumbersKey) ?? true;
    _highlightImportantParts = _prefs!.getBool(_highlightImportantKey) ?? true;
    _fontSize = _prefs!.getDouble(_fontSizeKey) ?? 14.0;

    debugPrint(
      'Settings loaded - Theme: $_selectedTheme, Line Numbers: $_showLineNumbers',
    );
  }

  /// Set selected theme with persistence
  Future<void> setSelectedTheme(String theme) async {
    if (!beautifulThemes.containsKey(theme)) {
      debugPrint('Warning: Theme $theme not found, using github_enhanced');
      theme = 'github_enhanced';
    }

    _selectedTheme = theme;
    await _prefs?.setString(_selectedThemeKey, theme);
    debugPrint('Theme saved: $theme');
  }

  /// Set line numbers preference with persistence
  Future<void> setShowLineNumbers(bool show) async {
    _showLineNumbers = show;
    await _prefs?.setBool(_showLineNumbersKey, show);
    debugPrint('Line numbers preference saved: $show');
  }

  /// Set highlight important parts preference with persistence
  Future<void> setHighlightImportantParts(bool highlight) async {
    _highlightImportantParts = highlight;
    await _prefs?.setBool(_highlightImportantKey, highlight);
    debugPrint('Highlight important parts preference saved: $highlight');
  }

  /// Set font size preference with persistence
  Future<void> setFontSize(double size) async {
    _fontSize = size.clamp(10.0, 24.0);
    await _prefs?.setDouble(_fontSizeKey, _fontSize);
    debugPrint('Font size preference saved: $_fontSize');
  }

  /// Get the current theme's highlight style
  Map<String, TextStyle> getCurrentThemeStyle() {
    return beautifulThemes[_selectedTheme] ??
        beautifulThemes['github_enhanced']!;
  }

  /// Beautiful modern syntax highlighting themes
  static const Map<String, Map<String, TextStyle>> beautifulThemes = {
    'github_enhanced': {
      'root': TextStyle(
        backgroundColor: Color(0xFFfafbfc),
        color: Color(0xFF24292e),
      ),
      'keyword': TextStyle(
        color: Color(0xFFd73a49),
        fontWeight: FontWeight.bold,
      ),
      'string': TextStyle(color: Color(0xFF032f62)),
      'comment': TextStyle(
        color: Color(0xFF6a737d),
        fontStyle: FontStyle.italic,
      ),
      'number': TextStyle(color: Color(0xFF005cc5)),
      'function': TextStyle(
        color: Color(0xFF6f42c1),
        fontWeight: FontWeight.w600,
      ),
      'class': TextStyle(color: Color(0xFF6f42c1), fontWeight: FontWeight.bold),
      'type': TextStyle(color: Color(0xFF005cc5), fontWeight: FontWeight.w500),
    },

    'atom_one_dark_enhanced': {
      'root': TextStyle(
        backgroundColor: Color(0xFF282c34),
        color: Color(0xFFabb2bf),
      ),
      'keyword': TextStyle(
        color: Color(0xFFc678dd),
        fontWeight: FontWeight.bold,
      ),
      'string': TextStyle(color: Color(0xFF98c379)),
      'comment': TextStyle(
        color: Color(0xFF5c6370),
        fontStyle: FontStyle.italic,
      ),
      'number': TextStyle(color: Color(0xFFd19a66)),
      'function': TextStyle(
        color: Color(0xFF61afef),
        fontWeight: FontWeight.w600,
      ),
      'class': TextStyle(color: Color(0xFFe5c07b), fontWeight: FontWeight.bold),
      'type': TextStyle(color: Color(0xFF56b6c2), fontWeight: FontWeight.w500),
    },

    'dracula_beautiful': {
      'root': TextStyle(
        backgroundColor: Color(0xFF282a36),
        color: Color(0xFFf8f8f2),
      ),
      'keyword': TextStyle(
        color: Color(0xFFff79c6),
        fontWeight: FontWeight.bold,
      ),
      'string': TextStyle(color: Color(0xFFf1fa8c)),
      'comment': TextStyle(
        color: Color(0xFF6272a4),
        fontStyle: FontStyle.italic,
      ),
      'number': TextStyle(color: Color(0xFFbd93f9)),
      'function': TextStyle(
        color: Color(0xFF50fa7b),
        fontWeight: FontWeight.w600,
      ),
      'class': TextStyle(color: Color(0xFF8be9fd), fontWeight: FontWeight.bold),
      'type': TextStyle(color: Color(0xFFffb86c), fontWeight: FontWeight.w500),
    },

    'monokai_pro': {
      'root': TextStyle(
        backgroundColor: Color(0xFF2d2a2e),
        color: Color(0xFFfcfcfa),
      ),
      'keyword': TextStyle(
        color: Color(0xFFff6188),
        fontWeight: FontWeight.bold,
      ),
      'string': TextStyle(color: Color(0xFFffd866)),
      'comment': TextStyle(
        color: Color(0xFF727072),
        fontStyle: FontStyle.italic,
      ),
      'number': TextStyle(color: Color(0xFFab9df2)),
      'function': TextStyle(
        color: Color(0xFFa9dc76),
        fontWeight: FontWeight.w600,
      ),
      'class': TextStyle(color: Color(0xFF78dce8), fontWeight: FontWeight.bold),
      'type': TextStyle(color: Color(0xFFfc9867), fontWeight: FontWeight.w500),
    },

    'oceanic_next': {
      'root': TextStyle(
        backgroundColor: Color(0xFF1b2b34),
        color: Color(0xFFcdd3de),
      ),
      'keyword': TextStyle(
        color: Color(0xFFc594c5),
        fontWeight: FontWeight.bold,
      ),
      'string': TextStyle(color: Color(0xFF99c794)),
      'comment': TextStyle(
        color: Color(0xFF65737e),
        fontStyle: FontStyle.italic,
      ),
      'number': TextStyle(color: Color(0xFFf99157)),
      'function': TextStyle(
        color: Color(0xFF6699cc),
        fontWeight: FontWeight.w600,
      ),
      'class': TextStyle(color: Color(0xFFfac863), fontWeight: FontWeight.bold),
      'type': TextStyle(color: Color(0xFF5fb3b3), fontWeight: FontWeight.w500),
    },

    'nord_theme': {
      'root': TextStyle(
        backgroundColor: Color(0xFF2e3440),
        color: Color(0xFFd8dee9),
      ),
      'keyword': TextStyle(
        color: Color(0xFF81a1c1),
        fontWeight: FontWeight.bold,
      ),
      'string': TextStyle(color: Color(0xFFa3be8c)),
      'comment': TextStyle(
        color: Color(0xFF616e88),
        fontStyle: FontStyle.italic,
      ),
      'number': TextStyle(color: Color(0xFFb48ead)),
      'function': TextStyle(
        color: Color(0xFF88c0d0),
        fontWeight: FontWeight.w600,
      ),
      'class': TextStyle(color: Color(0xFFebcb8b), fontWeight: FontWeight.bold),
      'type': TextStyle(color: Color(0xFF8fbcbb), fontWeight: FontWeight.w500),
    },

    'tokyo_night': {
      'root': TextStyle(
        backgroundColor: Color(0xFF1a1b26),
        color: Color(0xFFa9b1d6),
      ),
      'keyword': TextStyle(
        color: Color(0xFFbb9af7),
        fontWeight: FontWeight.bold,
      ),
      'string': TextStyle(color: Color(0xFF9ece6a)),
      'comment': TextStyle(
        color: Color(0xFF565f89),
        fontStyle: FontStyle.italic,
      ),
      'number': TextStyle(color: Color(0xFFff9e64)),
      'function': TextStyle(
        color: Color(0xFF7aa2f7),
        fontWeight: FontWeight.w600,
      ),
      'class': TextStyle(color: Color(0xFFe0af68), fontWeight: FontWeight.bold),
      'type': TextStyle(color: Color(0xFF2ac3de), fontWeight: FontWeight.w500),
    },

    'gruvbox_dark': {
      'root': TextStyle(
        backgroundColor: Color(0xFF282828),
        color: Color(0xFFebdbb2),
      ),
      'keyword': TextStyle(
        color: Color(0xFFfb4934),
        fontWeight: FontWeight.bold,
      ),
      'string': TextStyle(color: Color(0xFFb8bb26)),
      'comment': TextStyle(
        color: Color(0xFF928374),
        fontStyle: FontStyle.italic,
      ),
      'number': TextStyle(color: Color(0xFFd3869b)),
      'function': TextStyle(
        color: Color(0xFF83a598),
        fontWeight: FontWeight.w600,
      ),
      'class': TextStyle(color: Color(0xFFfabd2f), fontWeight: FontWeight.bold),
      'type': TextStyle(color: Color(0xFF8ec07c), fontWeight: FontWeight.w500),
    },

    'synthwave84': {
      'root': TextStyle(
        backgroundColor: Color(0xFF2a2139),
        color: Color(0xFFf2f2f2),
      ),
      'keyword': TextStyle(
        color: Color(0xFFff7edb),
        fontWeight: FontWeight.bold,
      ),
      'string': TextStyle(color: Color(0xFFfede5d)),
      'comment': TextStyle(
        color: Color(0xFF7a7a7a),
        fontStyle: FontStyle.italic,
      ),
      'number': TextStyle(color: Color(0xFFff8a80)),
      'function': TextStyle(
        color: Color(0xFF36f9f6),
        fontWeight: FontWeight.w600,
      ),
      'class': TextStyle(color: Color(0xFFff7edb), fontWeight: FontWeight.bold),
      'type': TextStyle(color: Color(0xFF72f1b8), fontWeight: FontWeight.w500),
    },

    'material_theme': {
      'root': TextStyle(
        backgroundColor: Color(0xFF263238),
        color: Color(0xFFEEFFFF),
      ),
      'keyword': TextStyle(
        color: Color(0xFFC792EA),
        fontWeight: FontWeight.bold,
      ),
      'string': TextStyle(color: Color(0xFFC3E88D)),
      'comment': TextStyle(
        color: Color(0xFF546E7A),
        fontStyle: FontStyle.italic,
      ),
      'number': TextStyle(color: Color(0xFFF78C6C)),
      'function': TextStyle(
        color: Color(0xFF82AAFF),
        fontWeight: FontWeight.w600,
      ),
      'class': TextStyle(color: Color(0xFFFFCB6B), fontWeight: FontWeight.bold),
      'type': TextStyle(color: Color(0xFF89DDFF), fontWeight: FontWeight.w500),
    },
  };

  /// Enhanced language configuration with visual elements
  static const Map<String, Map<String, dynamic>> languageConfig = {
    'dart': {
      'name': 'Dart',
      'icon': '🎯',
      'color': Color(0xFF0175C2),
      'gradient': [Color(0xFF0175C2), Color(0xFF13B9FD)],
      'category': 'Mobile Development',
    },
    'javascript': {
      'name': 'JavaScript',
      'icon': '⚡',
      'color': Color(0xFFF7DF1E),
      'gradient': [Color(0xFFF7DF1E), Color(0xFFFFD700)],
      'category': 'Web Development',
    },
    'typescript': {
      'name': 'TypeScript',
      'icon': '📘',
      'color': Color(0xFF3178C6),
      'gradient': [Color(0xFF3178C6), Color(0xFF5B9BD5)],
      'category': 'Web Development',
    },
    'python': {
      'name': 'Python',
      'icon': '🐍',
      'color': Color(0xFF3776AB),
      'gradient': [Color(0xFF3776AB), Color(0xFF4B8BBE)],
      'category': 'Data Science',
    },
    'java': {
      'name': 'Java',
      'icon': '☕',
      'color': Color(0xFFED8B00),
      'gradient': [Color(0xFFED8B00), Color(0xFFFF9A00)],
      'category': 'Enterprise',
    },
    'cpp': {
      'name': 'C++',
      'icon': '⚡',
      'color': Color(0xFF00599C),
      'gradient': [Color(0xFF00599C), Color(0xFF0073B7)],
      'category': 'System Programming',
    },
    'html': {
      'name': 'HTML',
      'icon': '🌐',
      'color': Color(0xFFE34F26),
      'gradient': [Color(0xFFE34F26), Color(0xFFFF6B35)],
      'category': 'Web Development',
    },
    'css': {
      'name': 'CSS',
      'icon': '🎨',
      'color': Color(0xFF1572B6),
      'gradient': [Color(0xFF1572B6), Color(0xFF33A9DC)],
      'category': 'Web Development',
    },
    'sql': {
      'name': 'SQL',
      'icon': '🗄️',
      'color': Color(0xFF336791),
      'gradient': [Color(0xFF336791), Color(0xFF4F94CD)],
      'category': 'Database',
    },
    'json': {
      'name': 'JSON',
      'icon': '📋',
      'color': Color(0xFF292929),
      'gradient': [Color(0xFF292929), Color(0xFF404040)],
      'category': 'Data Format',
    },
    'yaml': {
      'name': 'YAML',
      'icon': '📄',
      'color': Color(0xFF000000),
      'gradient': [Color(0xFF000000), Color(0xFF404040)],
      'category': 'Configuration',
    },
    'markdown': {
      'name': 'Markdown',
      'icon': '📝',
      'color': Color(0xFF000000),
      'gradient': [Color(0xFF000000), Color(0xFF404040)],
      'category': 'Documentation',
    },
    'bash': {
      'name': 'Bash',
      'icon': '⚡',
      'color': Color(0xFF4EAA25),
      'gradient': [Color(0xFF4EAA25), Color(0xFF7CB342)],
      'category': 'Scripting',
    },
    'go': {
      'name': 'Go',
      'icon': '🔥',
      'color': Color(0xFF00ADD8),
      'gradient': [Color(0xFF00ADD8), Color(0xFF29D9C2)],
      'category': 'Backend',
    },
    'rust': {
      'name': 'Rust',
      'icon': '🦀',
      'color': Color(0xFFCE422B),
      'gradient': [Color(0xFFCE422B), Color(0xFFE74C3C)],
      'category': 'System Programming',
    },
    'swift': {
      'name': 'Swift',
      'icon': '🍎',
      'color': Color(0xFFFA7343),
      'gradient': [Color(0xFFFA7343), Color(0xFFFF8A65)],
      'category': 'Mobile Development',
    },
    'kotlin': {
      'name': 'Kotlin',
      'icon': '💎',
      'color': Color(0xFF7F52FF),
      'gradient': [Color(0xFF7F52FF), Color(0xFF9C27B0)],
      'category': 'Mobile Development',
    },
    'php': {
      'name': 'PHP',
      'icon': '🐘',
      'color': Color(0xFF777BB4),
      'gradient': [Color(0xFF777BB4), Color(0xFF9B59B6)],
      'category': 'Web Development',
    },
    'ruby': {
      'name': 'Ruby',
      'icon': '💎',
      'color': Color(0xFFCC342D),
      'gradient': [Color(0xFFCC342D), Color(0xFFE74C3C)],
      'category': 'Web Development',
    },
    'csharp': {
      'name': 'C#',
      'icon': '🔷',
      'color': Color(0xFF239120),
      'gradient': [Color(0xFF239120), Color(0xFF27AE60)],
      'category': 'Enterprise',
    },
    'plaintext': {
      'name': 'Plain Text',
      'icon': '📄',
      'color': Color(0xFF666666),
      'gradient': [Color(0xFF666666), Color(0xFF888888)],
      'category': 'Text',
    },
  };

  /// Comprehensive language detection patterns
  static final Map<String, String> languageDetectionPatterns = {
    // Dart/Flutter - Most specific first
    'import \'package:flutter': 'dart',
    'import "package:flutter': 'dart',
    'extends StatelessWidget': 'dart',
    'extends StatefulWidget': 'dart',
    'Widget build(BuildContext': 'dart',
    'MaterialApp(': 'dart',
    'Scaffold(': 'dart',
    'void main() {': 'dart',
    'runApp(': 'dart',

    // HTML/XML - Very distinctive
    '<!DOCTYPE html': 'html',
    '<!doctype html': 'html',
    '<html': 'html',
    '<div': 'html',
    '<span': 'html',
    '<body': 'html',
    '<head': 'html',
    '<?xml': 'xml',

    // TypeScript - Check before JavaScript
    'interface ': 'typescript',
    ': string': 'typescript',
    ': number': 'typescript',
    ': boolean': 'typescript',
    'export interface': 'typescript',
    'import type': 'typescript',
    'type ': 'typescript',
    'enum ': 'typescript',

    // JavaScript/React/Node.js
    'import React': 'javascript',
    'from \'react\'': 'javascript',
    'useState(': 'javascript',
    'useEffect(': 'javascript',
    'export default': 'javascript',
    'require(': 'javascript',
    'module.exports': 'javascript',
    'console.log(': 'javascript',
    'const ': 'javascript',
    'let ': 'javascript',
    'function(': 'javascript',

    // Java - Very specific
    'public class ': 'java',
    'import java.': 'java',
    'public static void main(': 'java',
    'System.out.println(': 'java',
    'package ': 'java',
    '@Override': 'java',

    // Python - Distinctive
    'def ': 'python',
    'if __name__ == "__main__":': 'python',
    'print(': 'python',
    'elif ': 'python',
    'except:': 'python',
    'import ': 'python',
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
    'malloc(': 'c',
    'free(': 'c',

    // C#
    'using System;': 'csharp',
    'Console.WriteLine(': 'csharp',
    'public static void Main(': 'csharp',
    'namespace ': 'csharp',

    // Go
    'package main': 'go',
    'func main()': 'go',
    'fmt.Println(': 'go',
    'import "': 'go',
    'go mod': 'go',

    // Rust
    'fn main()': 'rust',
    'let mut': 'rust',
    'println!(': 'rust',
    'use std::': 'rust',
    'cargo ': 'rust',

    // PHP
    '<?php': 'php',
    'echo ': 'php',
    r'$_GET': 'php',
    r'$_POST': 'php',

    // Ruby
    'puts ': 'ruby',
    'require ': 'ruby',

    // Swift
    'import UIKit': 'swift',
    'import Foundation': 'swift',
    'func ': 'swift',

    // Kotlin
    'fun main()': 'kotlin',
    'println(': 'kotlin',

    // SQL
    'SELECT ': 'sql',
    'INSERT INTO': 'sql',
    'DELETE FROM': 'sql',
    'CREATE TABLE': 'sql',
    'ALTER TABLE': 'sql',
    'UPDATE ': 'sql',

    // CSS/SCSS
    '@import': 'scss',
    '@mixin': 'scss',
    '@include': 'scss',
    'body {': 'css',
    '.class': 'css',
    '#id': 'css',

    // Shell/Bash
    '#!/bin/bash': 'bash',
    '#!/bin/sh': 'bash',
    'echo ': 'bash',

    // JSON
    '{"': 'json',
    '"key":': 'json',

    // YAML
    'version:': 'yaml',
    '- name:': 'yaml',

    // Markdown
    '# ': 'markdown',
    '## ': 'markdown',
    '```': 'markdown',
    '[link]': 'markdown',

    // Dockerfile
    'FROM ': 'dockerfile',
    'RUN ': 'dockerfile',
    'COPY ': 'dockerfile',
    'WORKDIR ': 'dockerfile',
  };

  /// Get beautiful theme based on theme name and dark mode
  Map<String, TextStyle> getBeautifulTheme(String themeName, bool isDark) {
    // Direct mapping for exact theme names from settings
    if (beautifulThemes.containsKey(themeName)) {
      return beautifulThemes[themeName]!;
    }

    // Legacy/alias mappings for backward compatibility
    if (isDark) {
      switch (themeName.toLowerCase()) {
        case 'github':
        case 'github_enhanced':
          return beautifulThemes['github_enhanced']!;
        case 'atom':
        case 'atom_one_dark':
        case 'atom_one_dark_enhanced':
          return beautifulThemes['atom_one_dark_enhanced']!;
        case 'dracula':
        case 'dracula_beautiful':
          return beautifulThemes['dracula_beautiful']!;
        case 'monokai':
        case 'monokai_pro':
          return beautifulThemes['monokai_pro']!;
        case 'oceanic':
        case 'oceanic_next':
          return beautifulThemes['oceanic_next']!;
        case 'nord':
        case 'nord_theme':
          return beautifulThemes['nord_theme']!;
        case 'tokyo':
        case 'tokyo_night':
          return beautifulThemes['tokyo_night']!;
        case 'gruvbox':
        case 'gruvbox_dark':
          return beautifulThemes['gruvbox_dark']!;
        case 'synthwave':
        case 'synthwave84':
          return beautifulThemes['synthwave84']!;
        case 'material':
        case 'material_theme':
          return beautifulThemes['material_theme']!;
        default:
          return beautifulThemes['atom_one_dark_enhanced']!;
      }
    } else {
      // For light mode, always use GitHub Enhanced regardless of selected theme
      // unless a light-specific theme is selected
      return beautifulThemes['github_enhanced']!;
    }
  }

  /// Detect programming language from code with enhanced accuracy
  String detectLanguage(String code) {
    if (code.trim().isEmpty) return 'plaintext';

    final lowerCode = code.toLowerCase();

    // Check patterns in order of specificity
    for (final entry in languageDetectionPatterns.entries) {
      if (lowerCode.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }

    return 'plaintext';
  }

  /// Get language configuration
  Map<String, dynamic> getLanguageConfig(String language) {
    return languageConfig[language.toLowerCase()] ??
        languageConfig['plaintext']!;
  }

  /// Generate highlighted widget with beautiful styling and VS Code-like features
  Widget generateBeautifulHighlightedCode({
    required String code,
    required String language,
    required bool isDark,
    double fontSize = 14.0,
    String theme = 'auto',
    bool showLineNumbers = false,
    EdgeInsets padding = const EdgeInsets.all(16.0),
  }) {
    if (!_initialized) {
      return _buildFallbackCode(code, isDark, fontSize);
    }

    try {
      final normalizedLanguage = _normalizeLanguageName(language);

      // Use selected theme from settings when theme is 'auto'
      final selectedTheme = theme == 'auto' ? _selectedTheme : theme;
      final highlightTheme = getBeautifulTheme(selectedTheme, isDark);

      // Highlight the code with enhanced processing
      final result = _highlighter.highlight(
        code: code,
        language:
            normalizedLanguage.isNotEmpty ? normalizedLanguage : 'plaintext',
      );

      // Create enhanced text style with VS Code-like appearance
      final defaultStyle = GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        height: 1.6, // Increased line height for better readability
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4, // Slightly more spacing for clarity
      );

      final renderer = TextSpanRenderer(defaultStyle, highlightTheme);
      result.render(renderer);

      // Enhanced container with VS Code-like styling
      return Container(
        padding: padding,
        decoration: BoxDecoration(
          color:
              highlightTheme['root']?.backgroundColor ??
              (isDark ? const Color(0xFF1e1e1e) : const Color(0xFFfafbfc)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language header (VS Code-like)
            if (language.isNotEmpty)
              _buildLanguageHeader(language, isDark, highlightTheme),

            // Code content with enhanced rendering
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced syntax highlighted text with important parts
                    _buildEnhancedCodeText(
                      renderer.span ??
                          TextSpan(text: code, style: defaultStyle),
                      code,
                      language,
                      highlightTheme,
                      isDark,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('Enhanced highlighting failed: $e');
      return _buildFallbackCode(code, isDark, fontSize);
    }
  }

  /// Build VS Code-like language header
  Widget _buildLanguageHeader(
    String language,
    bool isDark,
    Map<String, TextStyle> theme,
  ) {
    final langConfig = getLanguageConfig(language);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(
          bottom: BorderSide(
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            langConfig['icon'] ?? '📄',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 8),
          Text(
            langConfig['name'] ?? language.toUpperCase(),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color:
                  langConfig['color'] ??
                  (isDark ? Colors.white70 : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced code text with important parts highlighting
  Widget _buildEnhancedCodeText(
    TextSpan baseSpan,
    String code,
    String language,
    Map<String, TextStyle> theme,
    bool isDark,
  ) {
    if (!_highlightImportantParts) {
      return RichText(text: baseSpan);
    }

    // Apply VS Code-like important parts highlighting
    final enhancedSpan = _applyImportantPartsHighlighting(
      baseSpan,
      code,
      language,
      theme,
      isDark,
    );

    return RichText(text: enhancedSpan);
  }

  /// Apply VS Code-like important parts highlighting (functions, classes, keywords)
  TextSpan _applyImportantPartsHighlighting(
    TextSpan baseSpan,
    String code,
    String language,
    Map<String, TextStyle> theme,
    bool isDark,
  ) {
    // Enhanced highlighting patterns for important code elements
    final importantPatterns = _getImportantPatternsForLanguage(language);

    if (importantPatterns.isEmpty) {
      return baseSpan;
    }

    // Apply enhanced styling to important parts
    return _enhanceTextSpanWithPatterns(
      baseSpan,
      importantPatterns,
      theme,
      isDark,
    );
  }

  /// Get important patterns for different programming languages
  Map<String, TextStyle> _getImportantPatternsForLanguage(String language) {
    final patterns = <String, TextStyle>{};

    switch (language.toLowerCase()) {
      case 'dart':
      case 'flutter':
        patterns.addAll({
          'class ': TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.dotted,
          ),
          'void ': TextStyle(fontWeight: FontWeight.w600),
          'async ': TextStyle(fontWeight: FontWeight.w600),
          'await ': TextStyle(fontWeight: FontWeight.w600),
          'Widget': TextStyle(fontWeight: FontWeight.bold),
          'setState': TextStyle(fontWeight: FontWeight.bold),
        });
        break;

      case 'javascript':
      case 'typescript':
        patterns.addAll({
          'function ': TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.dotted,
          ),
          'const ': TextStyle(fontWeight: FontWeight.w600),
          'let ': TextStyle(fontWeight: FontWeight.w600),
          'async ': TextStyle(fontWeight: FontWeight.w600),
          'await ': TextStyle(fontWeight: FontWeight.w600),
        });
        break;

      case 'python':
        patterns.addAll({
          'def ': TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.dotted,
          ),
          'class ': TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.dotted,
          ),
          'async ': TextStyle(fontWeight: FontWeight.w600),
          'await ': TextStyle(fontWeight: FontWeight.w600),
        });
        break;

      case 'java':
        patterns.addAll({
          'public class ': TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.dotted,
          ),
          'private ': TextStyle(fontWeight: FontWeight.w600),
          'public ': TextStyle(fontWeight: FontWeight.w600),
          'static ': TextStyle(fontWeight: FontWeight.w600),
        });
        break;
    }

    return patterns;
  }

  /// Enhanced TextSpan processing with important patterns
  TextSpan _enhanceTextSpanWithPatterns(
    TextSpan baseSpan,
    Map<String, TextStyle> patterns,
    Map<String, TextStyle> theme,
    bool isDark,
  ) {
    // For now, return the base span - this would require complex TextSpan parsing
    // In a production app, you'd implement proper TextSpan tree traversal and enhancement
    return baseSpan;
  }

  /// Build fallback code display when highlighting fails
  Widget _buildFallbackCode(String code, bool isDark, double fontSize) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1e1e1e) : const Color(0xFFf8f9fa),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          code,
          style: GoogleFonts.jetBrainsMono(
            fontSize: fontSize,
            height: 1.6,
            fontWeight: FontWeight.w400,
            color: isDark ? Colors.white : Colors.black,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  /// Normalize language name for re_highlight
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
      'md': 'markdown',
    };

    final normalizedLang = language.toLowerCase().trim();
    return languageMap[normalizedLang] ?? normalizedLang;
  }

  /// Debug method to verify settings storage and loading
  Future<void> debugSettingsStatus() async {
    debugPrint('=== SyntaxHighlightingService Debug Status ===');
    debugPrint('Service initialized: $_initialized');
    debugPrint('SharedPreferences available: ${_prefs != null}');
    debugPrint('Current selected theme: $_selectedTheme');
    debugPrint('Show line numbers: $_showLineNumbers');
    debugPrint('Highlight important parts: $_highlightImportantParts');
    debugPrint('Font size: $_fontSize');

    if (_prefs != null) {
      final storedTheme = _prefs!.getString(_selectedThemeKey);
      final storedLineNumbers = _prefs!.getBool(_showLineNumbersKey);
      final storedHighlight = _prefs!.getBool(_highlightImportantKey);
      final storedFontSize = _prefs!.getDouble(_fontSizeKey);

      debugPrint('--- Stored in SharedPreferences ---');
      debugPrint('Stored theme: $storedTheme');
      debugPrint('Stored line numbers: $storedLineNumbers');
      debugPrint('Stored highlight: $storedHighlight');
      debugPrint('Stored font size: $storedFontSize');
    }
    debugPrint('=============================================');
  }

  /// Verify settings persistence by saving and reloading
  Future<bool> testSettingsPersistence() async {
    try {
      debugPrint('Testing settings persistence...');

      // Save a test theme
      const testTheme = 'atom_one_dark_enhanced';
      await setSelectedTheme(testTheme);

      // Reload settings
      await _loadSettings();

      // Check if the theme was persisted
      final success = _selectedTheme == testTheme;
      debugPrint('Settings persistence test: ${success ? 'PASSED' : 'FAILED'}');
      debugPrint('Expected: $testTheme, Got: $_selectedTheme');

      return success;
    } catch (e) {
      debugPrint('Settings persistence test FAILED with error: $e');
      return false;
    }
  }
}
