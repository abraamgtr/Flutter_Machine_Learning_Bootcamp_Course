import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/history_item.dart';

/// Service for managing code generation history
///
/// This service handles local storage and retrieval of code generation history
/// using SharedPreferences. It provides methods for adding, retrieving,
/// and managing the user's code generation history.
class HistoryService {
  /// SharedPreferences instance for local storage
  late SharedPreferences _prefs;

  /// Key for storing history data in SharedPreferences
  static const String _historyKey = 'code_generation_history';

  /// Maximum number of history items to store
  static const int _maxHistoryItems = 100;

  /// Initializes the service and loads existing history
  ///
  /// This method must be called before using any other methods.
  /// It sets up the SharedPreferences instance and loads existing history.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Adds a new history item
  ///
  /// [item] - The history item to add
  ///
  /// The item is added to the beginning of the list (most recent first).
  /// If the history exceeds the maximum limit, older items are removed.
  Future<void> addHistoryItem(HistoryItem item) async {
    final history = await getHistory();

    // Add new item to the beginning
    history.insert(0, item);

    // Limit the number of items
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }

    await _saveHistory(history);
  }

  /// Retrieves all history items
  ///
  /// Returns a list of [HistoryItem] objects ordered by timestamp (newest first).
  /// Returns an empty list if no history exists.
  Future<List<HistoryItem>> getHistory() async {
    final jsonString = _prefs.getString(_historyKey);
    if (jsonString == null) return [];

    try {
      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => HistoryItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If parsing fails, return empty list and clear corrupted data
      await clearHistory();
      return [];
    }
  }

  /// Deletes a specific history item by ID
  ///
  /// [id] - The unique identifier of the item to delete
  ///
  /// Returns true if the item was found and deleted, false otherwise.
  Future<bool> deleteHistoryItem(String id) async {
    final history = await getHistory();
    final originalLength = history.length;

    history.removeWhere((item) => item.id == id);

    if (history.length != originalLength) {
      await _saveHistory(history);
      return true;
    }

    return false;
  }

  /// Clears all history
  ///
  /// This permanently removes all stored history items.
  Future<void> clearHistory() async {
    await _prefs.remove(_historyKey);
  }

  /// Gets the total number of history items
  ///
  /// Returns the count of stored history items.
  Future<int> getHistoryCount() async {
    final history = await getHistory();
    return history.length;
  }

  /// Searches history items by prompt content
  ///
  /// [query] - The search query to match against prompts
  ///
  /// Returns a list of history items whose prompts contain the query string.
  /// The search is case-insensitive.
  Future<List<HistoryItem>> searchHistory(String query) async {
    if (query.trim().isEmpty) return [];

    final history = await getHistory();
    final lowerQuery = query.toLowerCase();

    return history
        .where((item) => item.prompt.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Gets history items from a specific date range
  ///
  /// [startDate] - The start date (inclusive)
  /// [endDate] - The end date (inclusive)
  ///
  /// Returns history items created within the specified date range.
  Future<List<HistoryItem>> getHistoryByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final history = await getHistory();

    return history
        .where(
          (item) =>
              item.timestamp.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              item.timestamp.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList();
  }

  /// Gets history items by model
  ///
  /// [model] - The model name to filter by
  ///
  /// Returns history items generated using the specified model.
  Future<List<HistoryItem>> getHistoryByModel(String model) async {
    final history = await getHistory();

    return history.where((item) => item.model == model).toList();
  }

  /// Gets total token usage across all history
  ///
  /// Returns the sum of all token usage from history items.
  Future<int> getTotalTokenUsage() async {
    final history = await getHistory();

    return history.fold<int>(0, (sum, item) => sum + item.tokenUsage);
  }

  /// Exports history as JSON string
  ///
  /// Returns a JSON string representation of all history items.
  /// This can be used for backup or sharing purposes.
  Future<String> exportHistory() async {
    final history = await getHistory();
    return json.encode(history.map((item) => item.toJson()).toList());
  }

  /// Imports history from JSON string
  ///
  /// [jsonString] - The JSON string containing history data
  /// [mergeWithExisting] - Whether to merge with existing history or replace it
  ///
  /// This method can be used to restore history from a backup.
  Future<bool> importHistory(
    String jsonString, {
    bool mergeWithExisting = true,
  }) async {
    try {
      final jsonList = json.decode(jsonString) as List<dynamic>;
      final importedHistory =
          jsonList
              .map((json) => HistoryItem.fromJson(json as Map<String, dynamic>))
              .toList();

      List<HistoryItem> finalHistory;

      if (mergeWithExisting) {
        final existingHistory = await getHistory();
        finalHistory = [...importedHistory, ...existingHistory];

        // Remove duplicates based on ID
        final uniqueHistory = <String, HistoryItem>{};
        for (final item in finalHistory) {
          uniqueHistory[item.id] = item;
        }
        finalHistory = uniqueHistory.values.toList();

        // Sort by timestamp (newest first)
        finalHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      } else {
        finalHistory = importedHistory;
      }

      // Limit the number of items
      if (finalHistory.length > _maxHistoryItems) {
        finalHistory = finalHistory.take(_maxHistoryItems).toList();
      }

      await _saveHistory(finalHistory);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Saves the history list to SharedPreferences
  Future<void> _saveHistory(List<HistoryItem> history) async {
    final jsonString = json.encode(
      history.map((item) => item.toJson()).toList(),
    );
    await _prefs.setString(_historyKey, jsonString);
  }
}
