// Example usage of the CodePreviewWidget
//
// This file demonstrates how to use the reusable CodePreviewWidget
// in your Flutter applications with various configurations.

import 'package:flutter/material.dart';
import 'lib/presentation/widgets/code_preview_widget.dart';

void main() {
  runApp(const CodePreviewExampleApp());
}

class CodePreviewExampleApp extends StatelessWidget {
  const CodePreviewExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Preview Widget Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const CodePreviewExamplePage(),
    );
  }
}

class CodePreviewExamplePage extends StatelessWidget {
  const CodePreviewExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Code Preview Widget Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Basic usage example
            const Text(
              'Basic Usage:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CodePreviewWidget(
              code: '''
void main() {
  print('Hello, World!');
  
  // Example function
  final result = calculateSum(5, 3);
  print('Sum: \$result');
}

int calculateSum(int a, int b) {
  return a + b;
}''',
              language: 'dart',
              height: 200,
            ),

            const SizedBox(height: 24),

            // Compact version
            const Text(
              'Compact Version (No Line Numbers):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CodePreviewWidget(
              code: '''
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.json({ message: 'Hello World!' });
});''',
              language: 'javascript',
              height: 150,
              showLineNumbers: false,
              fontSize: 12,
            ),

            const SizedBox(height: 24),

            // Mini preview (no copy button)
            const Text(
              'Mini Preview (No Copy Button):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CodePreviewWidget(
              code: '''
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)''',
              language: 'python',
              height: 120,
              showCopyButton: false,
              fontSize: 11,
              borderRadius: 8,
            ),

            const SizedBox(height: 24),

            // Custom styling
            const Text(
              'Custom Styling:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CodePreviewWidget(
              code: '''
<html>
<head>
    <title>My Web Page</title>
</head>
<body>
    <h1>Welcome!</h1>
    <p>This is a sample HTML page.</p>
</body>
</html>''',
              language: 'html',
              height: 180,
              fontSize: 13,
              borderRadius: 16,
              padding: const EdgeInsets.all(20),
              showShadow: true,
            ),

            const SizedBox(height: 24),

            // Usage instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Usage Instructions:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Import the CodePreviewWidget:\n'
                    '   import \'lib/presentation/widgets/code_preview_widget.dart\';\n\n'
                    '2. Use it in your widget tree:\n'
                    '   CodePreviewWidget(\n'
                    '     code: "your code here",\n'
                    '     language: "dart",\n'
                    '   )\n\n'
                    '3. Customize with optional parameters:\n'
                    '   - showLineNumbers: true/false\n'
                    '   - showCopyButton: true/false\n'
                    '   - showLanguageLabel: true/false\n'
                    '   - height: custom height\n'
                    '   - fontSize: custom font size\n'
                    '   - borderRadius: custom border radius\n'
                    '   - showShadow: true/false\n'
                    '   - forceDarkTheme: true/false\n',
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
