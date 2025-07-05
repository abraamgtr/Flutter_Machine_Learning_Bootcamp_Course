import 'package:flutter/foundation.dart';

/// Comprehensive language detection and normalization utility
///
/// This utility provides advanced language detection capabilities by analyzing
/// both code content and prompt context using pattern matching and language aliases.
/// It supports detection for all major programming languages, frameworks, and markup languages.
class LanguageDetectionUtils {
  /// Comprehensive language aliases mapping for normalization
  static const Map<String, String> _languageAliases = {
    // Common aliases
    'js': 'javascript',
    'ts': 'typescript',
    'py': 'python',
    'rb': 'ruby',
    'sh': 'bash',
    'dockerfile': 'docker',
    'yml': 'yaml',
    'c++': 'cpp',

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
    'mysql': 'sql',
    'mongodb': 'javascript',

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
    'csharp': 'csharp',
    'vb.net': 'vbnet',

    // Framework-specific
    'react': 'javascript',
    'angular': 'typescript',
    'node': 'javascript',
    'nodejs': 'javascript',
    'django': 'python',
    'flask': 'python',
    'fastapi': 'python',
    'spring': 'java',
    'laravel': 'php',
    'symfony': 'php',
    'rails': 'ruby',
    'express': 'javascript',
    'nextjs': 'javascript',
    'nuxt': 'javascript',
  };

  /// Detects programming language from code content and optional prompt
  ///
  /// This method uses a comprehensive multi-stage detection approach:
  /// 1. Prompt-based language hints with high priority
  /// 2. Code pattern matching with specific patterns
  /// 3. Structural analysis and context checking
  /// 4. Language normalization and alias resolution
  ///
  /// Returns the detected language name or 'plaintext' if no language is detected.
  static String detectLanguage(String code, [String? prompt]) {
    if (code.trim().isEmpty) return 'plaintext';

    final lowerPrompt = prompt?.toLowerCase() ?? '';

    // Stage 1: Prompt-based detection (highest priority)
    if (prompt != null && prompt.isNotEmpty) {
      final promptLanguage = _detectFromPrompt(lowerPrompt);
      if (promptLanguage != null) {
        debugPrint('Language detected from prompt: $promptLanguage');
        return _normalizeLanguage(promptLanguage);
      }
    }

    // Stage 2: Code pattern matching with scoring
    final scores = <String, int>{};

    // Dart/Flutter patterns
    int dartScore = 0;
    if (code.contains('class') && code.contains('Widget')) dartScore += 5;
    if (code.contains('import \'package:flutter')) dartScore += 5;
    if (code.contains('@override') && code.contains('build')) dartScore += 3;
    if (code.contains('StatefulWidget') || code.contains('StatelessWidget'))
      dartScore += 4;
    if (code.contains('void main()') && code.contains('runApp')) dartScore += 3;
    if (code.contains('late ') || code.contains('final ')) dartScore += 2;
    if (dartScore > 0) scores['dart'] = dartScore;

    // JavaScript patterns
    int jsScore = 0;
    if (code.contains('function ')) jsScore += 3;
    if (code.contains('const ') ||
        code.contains('let ') ||
        code.contains('var '))
      jsScore += 2;
    if (code.contains('=>')) jsScore += 2;
    if (code.contains('console.log')) jsScore += 3;
    if (code.contains('require(') ||
        code.contains('import') && code.contains('from'))
      jsScore += 2;
    if (code.contains('document.') || code.contains('window.')) jsScore += 3;
    if (jsScore > 0) scores['javascript'] = jsScore;

    // TypeScript patterns
    int tsScore = 0;
    if (code.contains('interface ')) tsScore += 4;
    if (code.contains('type ') && code.contains('=')) tsScore += 3;
    if (code.contains(': string') ||
        code.contains(': number') ||
        code.contains(': boolean'))
      tsScore += 3;
    if (code.contains('public ') ||
        code.contains('private ') ||
        code.contains('protected '))
      tsScore += 2;
    if (tsScore > 0) scores['typescript'] = tsScore;

    // Python patterns
    int pythonScore = 0;
    if (code.contains('def ')) pythonScore += 3;
    if (code.contains('class ') && code.contains(':')) pythonScore += 3;
    if (code.contains('import ') ||
        code.contains('from ') && code.contains(' import'))
      pythonScore += 2;
    if (code.contains('if __name__ == "__main__"')) pythonScore += 4;
    if (code.contains('self.') || code.contains('__init__')) pythonScore += 3;
    if (code.contains('print(')) pythonScore += 2;
    if (pythonScore > 0) scores['python'] = pythonScore;

    // Java patterns
    int javaScore = 0;
    if (code.contains('public class ')) javaScore += 4;
    if (code.contains('public static void main')) javaScore += 4;
    if (code.contains('import java.')) javaScore += 3;
    if (code.contains('@Override') || code.contains('@Annotation'))
      javaScore += 2;
    if (code.contains('System.out.print')) javaScore += 3;
    if (javaScore > 0) scores['java'] = javaScore;

    // C++ patterns
    int cppScore = 0;
    if (code.contains('#include <') || code.contains('#include "'))
      cppScore += 3;
    if (code.contains('using namespace std')) cppScore += 4;
    if (code.contains('std::')) cppScore += 3;
    if (code.contains('cout <<') || code.contains('cin >>')) cppScore += 3;
    if (code.contains('int main(')) cppScore += 3;
    if (cppScore > 0) scores['cpp'] = cppScore;

    // C# patterns
    int csharpScore = 0;
    if (code.contains('using System')) csharpScore += 4;
    if (code.contains('namespace ')) csharpScore += 3;
    if (code.contains('Console.WriteLine')) csharpScore += 4;
    if (code.contains('public string ') || code.contains('public int '))
      csharpScore += 2;
    if (csharpScore > 0) scores['csharp'] = csharpScore;

    // Go patterns
    int goScore = 0;
    if (code.contains('package main')) goScore += 4;
    if (code.contains('func main(')) goScore += 4;
    if (code.contains('func ')) goScore += 2;
    if (code.contains('fmt.Print')) goScore += 3;
    if (code.contains('import (')) goScore += 2;
    if (goScore > 0) scores['go'] = goScore;

    // Rust patterns
    int rustScore = 0;
    if (code.contains('fn main(')) rustScore += 4;
    if (code.contains('fn ')) rustScore += 2;
    if (code.contains('let ') || code.contains('let mut ')) rustScore += 2;
    if (code.contains('println!')) rustScore += 3;
    if (code.contains('use ')) rustScore += 2;
    if (rustScore > 0) scores['rust'] = rustScore;

    // PHP patterns
    int phpScore = 0;
    if (code.contains('<?php')) phpScore += 5;
    if (code.contains('function ') && code.contains('\$')) phpScore += 3;
    if (code.contains('echo ') || code.contains('print ')) phpScore += 2;
    if (code.contains('->')) phpScore += 2;
    if (phpScore > 0) scores['php'] = phpScore;

    // HTML patterns
    int htmlScore = 0;
    if (code.contains('<!DOCTYPE html>')) htmlScore += 5;
    if (code.contains('<html') ||
        code.contains('<head>') ||
        code.contains('<body>'))
      htmlScore += 3;
    if (code.contains('<div') || code.contains('<span') || code.contains('<p>'))
      htmlScore += 2;
    if (code.contains('<script') || code.contains('<style')) htmlScore += 2;
    if (htmlScore > 0) scores['html'] = htmlScore;

    // CSS patterns
    int cssScore = 0;
    if (code.contains('color:') || code.contains('background:')) cssScore += 2;
    if (code.contains('margin:') || code.contains('padding:')) cssScore += 2;
    if (code.contains('@media') || code.contains('@import')) cssScore += 3;
    if (code.contains('{') && code.contains('}') && code.contains(':'))
      cssScore += 1;
    if (cssScore > 0) scores['css'] = cssScore;

    // SQL patterns
    int sqlScore = 0;
    if (code.contains('SELECT') && code.contains('FROM')) sqlScore += 4;
    if (code.contains('INSERT INTO') ||
        code.contains('UPDATE') ||
        code.contains('DELETE'))
      sqlScore += 3;
    if (code.contains('WHERE ') || code.contains('ORDER BY')) sqlScore += 2;
    if (code.contains('CREATE TABLE') || code.contains('ALTER TABLE'))
      sqlScore += 3;
    if (sqlScore > 0) scores['sql'] = sqlScore;

    // JSON patterns
    int jsonScore = 0;
    if (code.trim().startsWith('{') || code.trim().startsWith('['))
      jsonScore += 2;
    if (code.contains('"') && code.contains(':')) jsonScore += 2;
    if (code.contains('true') ||
        code.contains('false') ||
        code.contains('null'))
      jsonScore += 1;
    if (jsonScore > 0) scores['json'] = jsonScore;

    // Stage 3: Find the highest scoring language
    if (scores.isNotEmpty) {
      final sortedLanguages =
          scores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

      final topLanguage = sortedLanguages.first.key;
      final topScore = sortedLanguages.first.value;

      // Require minimum confidence threshold
      if (topScore >= 2) {
        debugPrint(
          'Language detected from code patterns: $topLanguage (score: $topScore)',
        );
        return _normalizeLanguage(topLanguage);
      }
    }

    // Stage 4: Fallback detection for edge cases
    final fallbackLanguage = _detectFallback(code);
    if (fallbackLanguage != null) {
      debugPrint('Language detected from fallback: $fallbackLanguage');
      return _normalizeLanguage(fallbackLanguage);
    }

    debugPrint('No language detected, defaulting to plaintext');
    return 'plaintext';
  }

  /// Detects language from prompt content
  static String? _detectFromPrompt(String lowerPrompt) {
    // Comprehensive prompt-based detection
    final promptMappings = {
      'flutter': 'dart',
      'dart': 'dart',
      'python': 'python',
      'py': 'python',
      'django': 'python',
      'flask': 'python',
      'fastapi': 'python',
      'pytorch': 'python',
      'tensorflow': 'python',
      'pandas': 'python',
      'numpy': 'python',
      'javascript': 'javascript',
      'js': 'javascript',
      'node': 'javascript',
      'nodejs': 'javascript',
      'express': 'javascript',
      'react': 'javascript',
      'vue': 'javascript',
      'svelte': 'javascript',
      'angular': 'typescript',
      'typescript': 'typescript',
      'ts': 'typescript',
      'java': 'java',
      'spring': 'java',
      'android': 'java',
      'kotlin': 'kotlin',
      'swift': 'swift',
      'ios': 'swift',
      'objective-c': 'objectivec',
      'objc': 'objectivec',
      'c++': 'cpp',
      'cpp': 'cpp',
      'c#': 'csharp',
      'csharp': 'csharp',
      '.net': 'csharp',
      'dotnet': 'csharp',
      'go': 'go',
      'golang': 'go',
      'rust': 'rust',
      'php': 'php',
      'laravel': 'php',
      'symfony': 'php',
      'ruby': 'ruby',
      'rails': 'ruby',
      'html': 'html',
      'css': 'css',
      'scss': 'css',
      'sass': 'css',
      'sql': 'sql',
      'mysql': 'sql',
      'postgresql': 'sql',
      'sqlite': 'sql',
      'mongodb': 'javascript',
      'bash': 'bash',
      'shell': 'bash',
      'powershell': 'powershell',
      'docker': 'dockerfile',
      'dockerfile': 'dockerfile',
      'yaml': 'yaml',
      'yml': 'yaml',
      'json': 'json',
      'xml': 'xml',
      'markdown': 'markdown',
    };

    for (final entry in promptMappings.entries) {
      if (lowerPrompt.contains(entry.key)) {
        return entry.value;
      }
    }

    return null;
  }

  /// Fallback detection for edge cases
  static String? _detectFallback(String code) {
    // Simple fallback patterns for common structures
    if (code.contains('function') && code.contains('{')) return 'javascript';
    if (code.contains('def ') && code.contains(':')) return 'python';
    if (code.contains('class ') && code.contains('{')) return 'java';
    if (code.contains('<') && code.contains('>') && code.contains('/'))
      return 'html';
    if (code.contains('SELECT') || code.contains('INSERT')) return 'sql';
    if (code.contains('#include')) return 'cpp';
    if (code.contains('using System')) return 'csharp';
    if (code.contains('package main')) return 'go';
    if (code.contains('fn main')) return 'rust';

    return null;
  }

  /// Normalizes language name using aliases mapping
  static String _normalizeLanguage(String language) {
    final normalizedLang = language.toLowerCase().trim();
    return _languageAliases[normalizedLang] ?? normalizedLang;
  }

  /// Normalizes a language name (public method for external use)
  static String normalizeLanguageName(String language) {
    return _normalizeLanguage(language);
  }

  /// Gets all supported languages
  static List<String> getSupportedLanguages() {
    final languages = <String>{};
    languages.addAll([
      'dart',
      'javascript',
      'typescript',
      'python',
      'java',
      'cpp',
      'csharp',
      'go',
      'rust',
      'php',
      'html',
      'css',
      'sql',
      'json',
    ]);
    languages.addAll(_languageAliases.values);
    languages.remove('plaintext');
    return languages.toList()..sort();
  }

  /// Checks if a language is supported
  static bool isLanguageSupported(String language) {
    final normalized = _normalizeLanguage(language);
    final supportedLanguages = getSupportedLanguages();
    return supportedLanguages.contains(normalized) ||
        _languageAliases.containsValue(normalized);
  }
}
