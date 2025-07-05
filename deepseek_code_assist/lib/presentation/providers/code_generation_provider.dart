import 'package:flutter/foundation.dart';

import '../../core/error/exceptions.dart';
import '../../domain/entities/code_generation.dart';
import '../../domain/usecases/get_code_from_prompt_usecase.dart';
import '../../data/models/history_item.dart';
import '../../infrastructure/services/history_service.dart';

/// Provider for managing code generation state and operations
///
/// This provider handles the UI state for code generation including:
/// - Loading states during API calls
/// - Generated code results
/// - Error handling and display
/// - History management
/// - Connection status with caching and debouncing
class CodeGenerationProvider extends ChangeNotifier {
  /// Use case for code generation business logic
  final GetCodeFromPromptUseCase _getCodeFromPromptUseCase;

  /// Service for managing generation history
  final HistoryService _historyService;

  // State variables
  bool _isLoading = false;
  String _generatedCode = '';
  String _currentPrompt = '';
  String? _errorMessage;
  CodeGenerationResult? _lastResult;
  List<HistoryItem> _history = [];

  // Connection status caching
  bool? _lastConnectionStatus;
  DateTime? _lastConnectionCheck;
  static const Duration _connectionCacheDuration = Duration(minutes: 2);
  bool _isTestingConnection = false;

  CodeGenerationProvider(this._getCodeFromPromptUseCase, this._historyService) {
    _loadHistory();
  }

  // Getters
  bool get isLoading => _isLoading;
  String get generatedCode => _generatedCode;
  String get currentPrompt => _currentPrompt;
  String? get errorMessage => _errorMessage;
  CodeGenerationResult? get lastResult => _lastResult;
  List<HistoryItem> get history => List.unmodifiable(_history);
  bool get hasError => _errorMessage != null;
  bool get hasResult => _generatedCode.isNotEmpty;
  bool get isTestingConnection => _isTestingConnection;

  /// Generates code from the given prompt
  ///
  /// [prompt] - The user's coding prompt
  /// [model] - Optional model to use (defaults to deepseek-coder)
  /// [maxTokens] - Optional max tokens (defaults to 2048)
  /// [temperature] - Optional temperature (defaults to 0.1)
  Future<void> generateCode({
    required String prompt,
    String? model,
    int? maxTokens,
    double? temperature,
  }) async {
    if (prompt.trim().isEmpty) {
      _setError('Please enter a prompt to generate code.');
      return;
    }

    // Prevent multiple simultaneous generation requests
    if (_isLoading) {
      debugPrint('Generation already in progress, ignoring duplicate request');
      return;
    }

    _setLoading(true);
    _clearError();
    _currentPrompt = prompt;

    try {
      // Create parameters for the use case
      final params = CodeGenerationParams(
        prompt: prompt,
        model: model ?? 'deepseek-coder',
        maxTokens: maxTokens ?? 2048,
        temperature: temperature ?? 0.1,
      );

      // Execute the use case
      final result = await _getCodeFromPromptUseCase.call(params);

      // Update state with result
      _lastResult = result;
      _generatedCode = result.code;

      // Invalidate connection status on successful generation
      _lastConnectionStatus = true;
      _lastConnectionCheck = DateTime.now();

      // Save to history
      final historyItem = HistoryItem.fromApiData(
        prompt: prompt,
        generatedCode: result.code,
        model: result.model,
        tokenUsage: result.tokenUsage.total,
      );

      await _historyService.addHistoryItem(historyItem);
      await _loadHistory();
    } on ValidationException catch (e) {
      _setError('Invalid input: ${e.message}');
      _lastConnectionStatus = false;
      _lastConnectionCheck = DateTime.now();
    } on NetworkException catch (e) {
      _setError('Network error: ${e.message}');
      _lastConnectionStatus = false;
      _lastConnectionCheck = DateTime.now();
    } on AuthenticationException catch (e) {
      _setError('Authentication error: ${e.message}');
      _lastConnectionStatus = false;
      _lastConnectionCheck = DateTime.now();
    } on RateLimitException catch (e) {
      _setError('Rate limit exceeded: ${e.message}');
      _lastConnectionStatus = false;
      _lastConnectionCheck = DateTime.now();
    } on ServerException catch (e) {
      _setError('Server error: ${e.message}');
      _lastConnectionStatus = false;
      _lastConnectionCheck = DateTime.now();
    } catch (e) {
      _setError('Unexpected error: $e');
      _lastConnectionStatus = false;
      _lastConnectionCheck = DateTime.now();
    } finally {
      _setLoading(false);
    }
  }

  /// Clears the current generation result
  void clearResult() {
    _generatedCode = '';
    _lastResult = null;
    _currentPrompt = '';
    _clearError();
    notifyListeners();
  }

  /// Regenerates code using the last prompt
  Future<void> regenerateCode() async {
    if (_currentPrompt.isNotEmpty) {
      await generateCode(prompt: _currentPrompt);
    }
  }

  /// Tests the connection to the DeepSeek API with caching and debouncing
  Future<bool> testConnection() async {
    // Return cached result if still valid
    if (_lastConnectionStatus != null &&
        _lastConnectionCheck != null &&
        DateTime.now().difference(_lastConnectionCheck!) <
            _connectionCacheDuration) {
      return _lastConnectionStatus!;
    }

    // Prevent multiple simultaneous connection tests
    if (_isTestingConnection) {
      // Return last known status or false if unknown
      return _lastConnectionStatus ?? false;
    }

    try {
      _isTestingConnection = true;

      final isConnected = await _getCodeFromPromptUseCase.testConnection();

      _lastConnectionStatus = isConnected;
      _lastConnectionCheck = DateTime.now();

      return isConnected;
    } catch (e) {
      _lastConnectionStatus = false;
      _lastConnectionCheck = DateTime.now();
      return false;
    } finally {
      _isTestingConnection = false;
    }
  }

  /// Gets the cached connection status without making a new request
  bool? get cachedConnectionStatus => _lastConnectionStatus;

  /// Forces a connection test, ignoring cache
  Future<bool> forceTestConnection() async {
    _lastConnectionStatus = null;
    _lastConnectionCheck = null;
    return await testConnection();
  }

  /// Loads history from the history service
  Future<void> _loadHistory() async {
    try {
      _history = await _historyService.getHistory();
      notifyListeners();
    } catch (e) {
      // Handle history loading errors silently
      debugPrint('Failed to load history: $e');
    }
  }

  /// Deletes a history item
  Future<void> deleteHistoryItem(String id) async {
    try {
      final success = await _historyService.deleteHistoryItem(id);
      if (success) {
        await _loadHistory();
      }
    } catch (e) {
      _setError('Failed to delete history item: $e');
    }
  }

  /// Clears all history
  Future<void> clearHistory() async {
    try {
      await _historyService.clearHistory();
      await _loadHistory();
    } catch (e) {
      _setError('Failed to clear history: $e');
    }
  }

  /// Searches history with the given query
  Future<List<HistoryItem>> searchHistory(String query) async {
    try {
      return await _historyService.searchHistory(query);
    } catch (e) {
      _setError('Failed to search history: $e');
      return [];
    }
  }

  /// Gets total token usage from history
  Future<int> getTotalTokenUsage() async {
    try {
      return await _historyService.getTotalTokenUsage();
    } catch (e) {
      return 0;
    }
  }

  /// Loads code from a history item
  void loadFromHistory(HistoryItem item) {
    _currentPrompt = item.prompt;
    _generatedCode = item.generatedCode;
    _lastResult = CodeGenerationResult(
      code: item.generatedCode,
      model: item.model,
      tokenUsage: TokenUsage(
        prompt: 0, // Not stored in history
        completion: 0, // Not stored in history
        total: item.tokenUsage,
      ),
      timestamp: item.timestamp,
      id: item.id,
    );
    _clearError();
    notifyListeners();
  }

  /// Sets the loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Sets an error message
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Clears any error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Disposes of the provider
  @override
  void dispose() {
    super.dispose();
  }
}
