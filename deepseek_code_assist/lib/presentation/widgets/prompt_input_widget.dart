import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/utils/language_detection_utils.dart';
import '../providers/code_generation_provider.dart';
import '../pages/ide_code_preview_page.dart';

/// Widget for inputting code generation prompts
///
/// This widget provides a modern, user-friendly interface for entering prompts
/// including example suggestions, smart validation, and enhanced generation controls.
class PromptInputWidget extends StatefulWidget {
  const PromptInputWidget({super.key});

  @override
  State<PromptInputWidget> createState() => _PromptInputWidgetState();
}

class _PromptInputWidgetState extends State<PromptInputWidget>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  /// Enhanced list of example prompts categorized by programming language
  static const List<Map<String, String>> _examplePrompts = [
    {
      'prompt':
          'Create a Flutter widget that displays a beautiful animated loading indicator',
      'language': 'Flutter/Dart',
      'icon': '📱',
    },
    {
      'prompt':
          'Write a Python function to analyze CSV data and generate insights',
      'language': 'Python',
      'icon': '🐍',
    },
    {
      'prompt':
          'Generate a React component for a responsive navigation menu with animations',
      'language': 'React/JS',
      'icon': '⚛️',
    },
    {
      'prompt':
          'Create a REST API endpoint using Node.js and Express with validation',
      'language': 'Node.js',
      'icon': '🟢',
    },
    {
      'prompt':
          'Write a SQL query to analyze sales data and find top performers',
      'language': 'SQL',
      'icon': '🗄️',
    },
    {
      'prompt': 'Generate a responsive landing page with modern CSS animations',
      'language': 'HTML/CSS',
      'icon': '🎨',
    },
    {
      'prompt':
          'Create a machine learning model for image classification in PyTorch',
      'language': 'ML/Python',
      'icon': '🤖',
    },
    {
      'prompt': 'Build a Vue.js component for real-time data visualization',
      'language': 'Vue.js',
      'icon': '💚',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CodeGenerationProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceContainerLow,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
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
                // Enhanced header
                _buildModernHeader(context),

                const SizedBox(height: 20),

                // Enhanced text input field
                _buildModernTextInput(context, provider),

                const SizedBox(height: 20),

                // Modern action buttons
                _buildModernActionButtons(context, provider),

                const SizedBox(height: 24),

                // Enhanced example prompts
                _buildModernExamplePrompts(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the modern header section with enhanced design
  Widget _buildModernHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Simplified minimal header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Describe Your Coding Vision',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w300,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The more specific, the better the result',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the modern text input field with enhanced design
  Widget _buildModernTextInput(
    BuildContext context,
    CodeGenerationProvider provider,
  ) {
    final theme = Theme.of(context);
    final maxCharacters = 2000;
    final isDisabled = provider.isLoading;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale:
              _focusNode.hasFocus && !isDisabled ? _pulseAnimation.value : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isDisabled
                        ? theme.colorScheme.outline.withOpacity(0.2)
                        : _focusNode.hasFocus
                        ? theme.colorScheme.primary.withOpacity(0.8)
                        : theme.colorScheme.outline.withOpacity(0.3),
                width: _focusNode.hasFocus && !isDisabled ? 2 : 1,
              ),
              gradient: LinearGradient(
                colors: [
                  isDisabled
                      ? theme.colorScheme.surfaceContainer.withOpacity(0.5)
                      : theme.colorScheme.surfaceContainer,
                  isDisabled
                      ? theme.colorScheme.surfaceContainerLow.withOpacity(0.5)
                      : theme.colorScheme.surfaceContainerLow,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow:
                  _focusNode.hasFocus && !isDisabled
                      ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : null,
            ),
            child: Stack(
              children: [
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: !isDisabled,
                  maxLines: 5,
                  maxLength: maxCharacters,
                  decoration: InputDecoration(
                    hintText:
                        isDisabled
                            ? 'AI is generating your code...'
                            : 'Example: Create a beautiful Flutter app with animations that...',
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color:
                          isDisabled
                              ? theme.colorScheme.onSurface.withOpacity(0.3)
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                      fontStyle: FontStyle.italic,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.all(20),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        isDisabled ? Icons.hourglass_empty : Icons.code_rounded,
                        color:
                            isDisabled
                                ? theme.colorScheme.onSurface.withOpacity(0.3)
                                : _focusNode.hasFocus
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.6),
                        size: 24,
                      ),
                    ),
                    counterText: '',
                  ),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color:
                        isDisabled
                            ? theme.colorScheme.onSurface.withOpacity(0.5)
                            : theme.colorScheme.onSurface,
                  ),
                  onChanged: (value) {
                    setState(() {}); // Update character counter and UI
                  },
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty && !isDisabled) {
                      _generateCode(provider);
                    }
                  },
                  textInputAction: TextInputAction.send,
                ),

                // Loading overlay
                if (isDisabled)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Generating...',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
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
        );
      },
    );
  }

  /// Builds an enhanced example prompt card
  Widget _buildExamplePromptCard(
    BuildContext context,
    Map<String, String> example,
    CodeGenerationProvider provider,
  ) {
    final theme = Theme.of(context);
    final isDisabled = provider.isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color:
            isDisabled
                ? theme.colorScheme.surfaceContainerLow.withOpacity(0.5)
                : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDisabled
                  ? theme.colorScheme.outline.withOpacity(0.1)
                  : theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap:
              isDisabled
                  ? null
                  : () {
                    HapticFeedback.lightImpact();
                    _controller.text = example['prompt']!;
                    setState(() {});
                  },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      example['icon']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDisabled ? Colors.grey : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        example['language']!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color:
                              isDisabled
                                  ? theme.colorScheme.primary.withOpacity(0.5)
                                  : theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    example['prompt']!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          isDisabled
                              ? theme.colorScheme.onSurface.withOpacity(0.4)
                              : theme.colorScheme.onSurface.withOpacity(0.8),
                      height: 1.3,
                    ),
                    maxLines: 3,
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

  /// Builds the modern example prompts section
  Widget _buildModernExamplePrompts(
    BuildContext context,
    CodeGenerationProvider provider,
  ) {
    final theme = Theme.of(context);
    final isDisabled = provider.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb_rounded,
              size: 20,
              color:
                  isDisabled
                      ? theme.colorScheme.primary.withOpacity(0.5)
                      : theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Get Inspired',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    isDisabled
                        ? theme.colorScheme.primary.withOpacity(0.5)
                        : theme.colorScheme.primary,
              ),
            ),
            if (isDisabled) ...[
              const SizedBox(width: 8),
              Text(
                '(disabled during generation)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 16),

        // Enhanced example prompts grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
          ),
          itemCount: _examplePrompts.take(4).length,
          itemBuilder: (context, index) {
            final example = _examplePrompts[index];
            return _buildExamplePromptCard(context, example, provider);
          },
        ),
      ],
    );
  }

  /// Builds the modern action buttons section
  Widget _buildModernActionButtons(
    BuildContext context,
    CodeGenerationProvider provider,
  ) {
    final theme = Theme.of(context);
    final canGenerate =
        _controller.text.trim().isNotEmpty && !provider.isLoading;
    final characterCount = _controller.text.length;
    final maxCharacters = 2000;
    final isNearLimit = characterCount > maxCharacters * 0.8;
    final isDisabled = provider.isLoading;

    return Column(
      children: [
        // Minimal character counter
        Row(
          children: [
            Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(1),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (characterCount / maxCharacters).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isNearLimit
                              ? Colors.orange.withOpacity(0.8)
                              : theme.colorScheme.primary.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$characterCount/$maxCharacters',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Minimal action buttons row
        Row(
          children: [
            // Generate button - minimal design
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 48,
                decoration: BoxDecoration(
                  color:
                      canGenerate
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: canGenerate ? () => _generateCode(provider) : null,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (provider.isLoading)
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          else
                            Icon(
                              Icons.auto_awesome_rounded,
                              color:
                                  canGenerate
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurface.withOpacity(
                                        0.4,
                                      ),
                              size: 18,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            provider.isLoading ? 'Generating...' : 'Generate',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color:
                                  canGenerate
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurface.withOpacity(
                                        0.4,
                                      ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Clear button - minimal design
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    _controller.text.isNotEmpty && !isDisabled
                        ? theme.colorScheme.errorContainer.withOpacity(0.1)
                        : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border:
                    _controller.text.isNotEmpty && !isDisabled
                        ? Border.all(
                          color: theme.colorScheme.error.withOpacity(0.2),
                          width: 1,
                        )
                        : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap:
                      _controller.text.isNotEmpty && !isDisabled
                          ? _clearInput
                          : null,
                  child: Icon(
                    Icons.close_rounded,
                    color:
                        _controller.text.isNotEmpty && !isDisabled
                            ? theme.colorScheme.error.withOpacity(0.8)
                            : theme.colorScheme.onSurface.withOpacity(0.3),
                    size: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Random prompt button - minimal design
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    isDisabled
                        ? theme.colorScheme.surfaceContainerHighest
                        : theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: isDisabled ? null : _insertRandomPrompt,
                  child: Icon(
                    Icons.shuffle_rounded,
                    color:
                        isDisabled
                            ? theme.colorScheme.onSurface.withOpacity(0.3)
                            : theme.colorScheme.onSurface.withOpacity(0.7),
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Generates code using the current prompt
  Future<void> _generateCode(CodeGenerationProvider provider) async {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;

    HapticFeedback.mediumImpact();
    _focusNode.unfocus();

    try {
      await provider.generateCode(prompt: prompt);

      // Navigate to IDE code preview page after successful generation
      if (mounted && provider.hasResult) {
        await Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => IdeCodePreviewPage(
                  code: provider.generatedCode,
                  language: LanguageDetectionUtils.detectLanguage(
                    provider.generatedCode,
                    prompt,
                  ),
                  prompt: prompt,
                  result: provider.lastResult,
                ),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;

              var tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Clears the input field
  void _clearInput() {
    HapticFeedback.lightImpact();
    _controller.clear();
    setState(() {});
  }

  /// Inserts a random prompt from the examples
  void _insertRandomPrompt() {
    HapticFeedback.lightImpact();
    final random =
        _examplePrompts[DateTime.now().millisecond % _examplePrompts.length];
    _controller.text = random['prompt']!;
    setState(() {});
  }
}
