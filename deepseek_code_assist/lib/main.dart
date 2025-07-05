import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/di/injection_container.dart' as di;
import 'infrastructure/services/theme_service.dart';
import 'presentation/pages/home_page.dart';

/// Main entry point of the Flutter Coding Agent App
///
/// This educational app demonstrates clean architecture principles
/// and modern Flutter development practices while providing
/// AI-powered code generation capabilities using DeepSeek API.
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables from .env file
    await dotenv.load(fileName: '.env');

    // Initialize dependency injection container
    await di.init();

    // Run the app
    runApp(const DeepSeekCodeAssistApp());
  } catch (e) {
    // Handle initialization errors gracefully
    runApp(ErrorApp(error: e.toString()));
  }
}

/// Main application widget
///
/// This widget sets up the app structure including:
/// - Theme management with Provider
/// - Material 3 design system
/// - Navigation and routing
/// - Error handling
class DeepSeekCodeAssistApp extends StatelessWidget {
  const DeepSeekCodeAssistApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the app with ChangeNotifierProvider for theme management
    return ChangeNotifierProvider<ThemeService>(
      create: (_) => di.sl<ThemeService>(),
      child: Consumer<ThemeService>(
        builder: (context, themeService, _) {
          return MaterialApp(
            // App configuration
            title: 'CodeMuse',
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: themeService.lightTheme,
            darkTheme: themeService.darkTheme,
            themeMode: themeService.themeMode,

            // Home page
            home: const HomePage(),

            // Global error handling
            builder: (context, widget) {
              // Handle text scaling for accessibility
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(themeService.fontSizeScale),
                ),
                child: widget ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}

/// Error app widget displayed when initialization fails
///
/// This provides a user-friendly error screen when the app
/// fails to initialize properly, such as when environment
/// variables are missing or dependency injection fails.
class ErrorApp extends StatelessWidget {
  /// The error message to display
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeMuse - Error',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error icon
                const Icon(Icons.error_outline, size: 64, color: Colors.red),

                const SizedBox(height: 24),

                // Error title
                Text(
                  'Initialization Error',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Error message
                Text(
                  'The app failed to initialize properly. Please check your configuration and try again.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Technical details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Technical Details:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Common solutions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Common Solutions:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Ensure .env file exists with DEEPSEEK_API_KEY\n'
                        '• Check your internet connection\n'
                        '• Verify API key is valid\n'
                        '• Restart the application',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
