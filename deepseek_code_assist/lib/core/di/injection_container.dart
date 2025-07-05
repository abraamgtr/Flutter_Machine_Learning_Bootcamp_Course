import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/code_generation_remote_datasource.dart';
import '../../data/datasources/code_generation_remote_datasource_impl.dart';
import '../../data/repositories/code_generation_repository_impl.dart';
import '../../domain/repositories/code_generation_repository.dart';
import '../../domain/usecases/get_code_from_prompt_usecase.dart';
import '../../infrastructure/services/history_service.dart';
import '../../infrastructure/services/theme_service.dart';
import '../../infrastructure/services/syntax_highlighting_service.dart';

/// Global service locator instance
///
/// This provides access to all registered dependencies throughout the app.
/// It follows the service locator pattern for dependency injection.
final sl = GetIt.instance;

/// Initializes all dependencies in the proper order
///
/// This function should be called during app startup, before runApp().
/// It registers all dependencies with their appropriate lifetimes:
/// - Singletons for services that should persist throughout the app
/// - Factories for objects that should be created fresh each time
/// - LazySingletons for expensive objects that may not be used immediately
Future<void> init() async {
  //! Features - Code Generation
  _initCodeGeneration();

  //! Infrastructure Services
  await _initInfrastructureServices();

  //! External Dependencies
  _initExternalDependencies();
}

/// Initialize code generation feature dependencies
void _initCodeGeneration() {
  // Use Cases
  sl.registerLazySingleton(() => GetCodeFromPromptUseCase(sl()));

  // Repository
  sl.registerLazySingleton<CodeGenerationRepository>(
    () => CodeGenerationRepositoryImpl(sl()),
  );

  // Data Sources
  sl.registerLazySingleton<CodeGenerationRemoteDataSource>(
    () => CodeGenerationRemoteDataSourceImpl(dio: sl()),
  );
}

/// Initialize infrastructure services
Future<void> _initInfrastructureServices() async {
  // History Service - manages local storage of generation history
  final historyService = HistoryService();
  await historyService.init();
  sl.registerSingleton<HistoryService>(historyService);

  // Theme Service - manages app theme and preferences
  final themeService = ThemeService();
  await themeService.init();
  sl.registerSingleton<ThemeService>(themeService);

  // Syntax Highlighting Service - manages beautiful code highlighting
  final syntaxHighlightingService = SyntaxHighlightingService();
  await syntaxHighlightingService.initialize();
  sl.registerSingleton<SyntaxHighlightingService>(syntaxHighlightingService);
}

/// Initialize external dependencies
void _initExternalDependencies() {
  // HTTP Client
  sl.registerLazySingleton(() => Dio());
}

/// Resets all dependencies (useful for testing)
///
/// This method cleans up all registered dependencies and reinitializes them.
/// It's primarily used in testing scenarios to ensure clean state between tests.
Future<void> reset() async {
  await sl.reset();
  await init();
}

/// Gets a dependency of type T
///
/// This is a convenience method that provides a more readable way to access
/// dependencies compared to using sl<T>() directly.
///
/// Example:
/// ```dart
/// final useCase = get<GetCodeFromPromptUseCase>();
/// ```
T get<T extends Object>() => sl<T>();

/// Checks if a dependency of type T is registered
///
/// This is useful for conditional dependency access or validation.
bool isRegistered<T extends Object>() => sl.isRegistered<T>();

/// Registers a singleton dependency
///
/// This is a convenience method for registering dependencies at runtime.
/// It's primarily used for testing or dynamic dependency registration.
void registerSingleton<T extends Object>(T instance) {
  if (!sl.isRegistered<T>()) {
    sl.registerSingleton<T>(instance);
  }
}

/// Registers a lazy singleton dependency
///
/// This is a convenience method for registering lazy dependencies at runtime.
void registerLazySingleton<T extends Object>(T Function() factoryFunc) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(factoryFunc);
  }
}

/// Unregisters a dependency of type T
///
/// This is useful for cleaning up specific dependencies or replacing them
/// with different implementations.
Future<void> unregister<T extends Object>() async {
  if (sl.isRegistered<T>()) {
    await sl.unregister<T>();
  }
}
