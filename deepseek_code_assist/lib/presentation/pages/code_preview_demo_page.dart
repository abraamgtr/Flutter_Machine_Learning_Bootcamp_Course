import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../infrastructure/services/theme_service.dart';
import '../widgets/code_preview_widget.dart';

/// Simple and minimal code preview demo page
class CodePreviewDemoPage extends StatefulWidget {
  const CodePreviewDemoPage({super.key});

  @override
  State<CodePreviewDemoPage> createState() => _CodePreviewDemoPageState();
}

class _CodePreviewDemoPageState extends State<CodePreviewDemoPage> {
  int _selectedIndex = 0;

  // Simple, clean code examples with excellent syntax highlighting
  static final List<Map<String, String>> _codeExamples = [
    {
      'language': 'dart',
      'title': 'Flutter Widget',
      'code': '''
class WeatherCard extends StatelessWidget {
  const WeatherCard({
    super.key,
    required this.temperature,
    required this.location,
    required this.condition,
  });

  final double temperature;
  final String location;
  final String condition;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\${temperature.round()}°C',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Icon(
                  _getWeatherIcon(condition),
                  size: 48,
                  color: Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              condition,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.umbrella;
      default:
        return Icons.wb_sunny;
    }
  }
}''',
    },
    {
      'language': 'python',
      'title': 'Data Processing',
      'code': '''
import pandas as pd
import numpy as np
from datetime import datetime

class DataProcessor:
    def __init__(self, data_path):
        self.data_path = data_path
        self.df = None
        self.results = {}
    
    def load_data(self):
        """Load and validate the dataset"""
        try:
            self.df = pd.read_csv(self.data_path)
            print(f"Loaded {len(self.df)} records successfully")
            return self.df
        except Exception as e:
            print(f"Error loading data: {e}")
            return None
    
    def analyze_trends(self, column, window=7):
        """Analyze trends with rolling averages"""
        if self.df is None:
            raise ValueError("Data not loaded. Call load_data() first.")
        
        # Calculate rolling statistics
        rolling_mean = self.df[column].rolling(window=window).mean()
        rolling_std = self.df[column].rolling(window=window).std()
        
        # Detect anomalies
        anomalies = np.abs(self.df[column] - rolling_mean) > (2 * rolling_std)
        
        analysis = {
            'trend_direction': self._get_trend_direction(rolling_mean),
            'volatility': rolling_std.mean(),
            'anomaly_count': anomalies.sum(),
            'anomaly_percentage': (anomalies.sum() / len(self.df)) * 100
        }
        
        self.results[column] = analysis
        return analysis
    
    def _get_trend_direction(self, rolling_mean):
        """Determine if trend is increasing or decreasing"""
        if rolling_mean.iloc[-1] > rolling_mean.iloc[0]:
            return 'increasing'
        else:
            return 'decreasing'
    
    def generate_report(self):
        """Generate a comprehensive analysis report"""
        if not self.results:
            return "No analysis performed yet."
        
        report_lines = [
            "DATA ANALYSIS REPORT",
            "=" * 40,
            f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
            f"Dataset size: {len(self.df)} records",
            ""
        ]
        
        for column, analysis in self.results.items():
            report_lines.extend([
                f"Column: {column}",
                f"  Trend: {analysis['trend_direction']}",
                f"  Volatility: {analysis['volatility']:.2f}",
                f"  Anomalies: {analysis['anomaly_count']} records",
                ""
            ])
        
        return "\\n".join(report_lines)

# Usage example
if __name__ == "__main__":
    processor = DataProcessor("sales_data.csv")
    processor.load_data()
    processor.analyze_trends("revenue")
    processor.analyze_trends("customer_count")
    
    print(processor.generate_report())''',
    },
    {
      'language': 'javascript',
      'title': 'React Hook',
      'code': '''
import { useState, useEffect, useCallback } from 'react';

// Custom hook for API data fetching
export const useApiData = (url, options = {}) => {
  const [state, setState] = useState({
    data: null,
    loading: true,
    error: null,
    lastFetch: null
  });

  // Fetch function with caching
  const fetchData = useCallback(async (force = false) => {
    const now = Date.now();
    const cacheExpiry = 5 * 60 * 1000; // 5 minutes
    
    if (!force && state.lastFetch && (now - state.lastFetch) < cacheExpiry) {
      console.log('Using cached data');
      return;
    }

    try {
      setState(prev => ({ ...prev, loading: true, error: null }));
      
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 10000);
      
      const response = await fetch(url, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
        signal: controller.signal,
        ...options
      });
      
      clearTimeout(timeoutId);
      
      if (!response.ok) {
        throw new Error('HTTP ' + response.status + ': ' + response.statusText);
      }
      
      const data = await response.json();
      
      setState({
        data,
        loading: false,
        error: null,
        lastFetch: now
      });
      
      console.log('Data fetched successfully');
      
    } catch (error) {
      if (error.name === 'AbortError') {
        console.log('Request timeout');
        setState(prev => ({ 
          ...prev, 
          loading: false, 
          error: 'Request timeout' 
        }));
      } else {
        console.error('Fetch error:', error);
        setState(prev => ({ 
          ...prev, 
          loading: false, 
          error: error.message 
        }));
      }
    }
  }, [url, options, state.lastFetch]);

  // Auto-fetch on mount
  useEffect(() => {
    fetchData();
  }, [fetchData]);

  return {
    ...state,
    refetch: () => fetchData(true),
    isStale: state.lastFetch && (Date.now() - state.lastFetch) > 60000
  };
};

// Usage in component
export const UserProfile = ({ userId }) => {
  const apiUrl = 'https://api.example.com/users/' + userId;
  const { data: user, loading, error, refetch } = useApiData(apiUrl);

  if (loading) {
    return (
      <div className="flex items-center justify-center p-8">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500" />
        <span className="ml-2 text-gray-600">Loading user...</span>
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-red-50 border border-red-200 rounded-lg p-4">
        <p className="text-red-800">Error: {error}</p>
        <button 
          onClick={refetch}
          className="mt-2 px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
        >
          Retry
        </button>
      </div>
    );
  }

  return (
    <div className="bg-white shadow-lg rounded-lg p-6">
      <div className="flex items-center space-x-4">
        <img 
          src={user.avatar} 
          alt={user.name}
          className="w-16 h-16 rounded-full object-cover"
        />
        <div>
          <h2 className="text-xl font-bold text-gray-900">{user.name}</h2>
          <p className="text-gray-600">{user.email}</p>
          <span className="inline-block px-2 py-1 text-xs rounded-full bg-green-100 text-green-800">
            {user.status}
          </span>
        </div>
      </div>
    </div>
  );
};''',
    },
    {
      'language': 'html',
      'title': 'Simple Card',
      'code': '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Card Example</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
            margin: 0;
        }
        .card {
            max-width: 400px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
        }
        .card-title {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
        }
        .card-subtitle {
            margin: 5px 0 0 0;
            opacity: 0.9;
            font-size: 14px;
        }
        .card-content {
            padding: 20px;
        }
        .card-text {
            color: #666;
            line-height: 1.5;
            margin-bottom: 15px;
        }
        .button {
            background: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s;
        }
        .button:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">Beautiful Card</h2>
            <p class="card-subtitle">Clean and minimal design</p>
        </div>
        <div class="card-content">
            <p class="card-text">
                This is a simple, clean card component with a beautiful gradient header 
                and well-structured content area. Perfect for displaying information 
                in an organized and visually appealing way.
            </p>
            <button class="button">Learn More</button>
        </div>
    </div>
</body>
</html>''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final isDark = themeService.isDarkMode;

        return Scaffold(
          backgroundColor:
              isDark ? const Color(0xFF0D1117) : const Color(0xFFFAFBFC),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: isDark ? const Color(0xFF21262D) : Colors.white,
            title: Text(
              'Code Preview',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF24292e),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => themeService.toggleTheme(),
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: isDark ? Colors.white : const Color(0xFF24292e),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Simple language selector
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color:
                    isDark ? const Color(0xFF161B22) : const Color(0xFFF6F8FA),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _codeExamples.length,
                  itemBuilder: (context, index) {
                    final example = _codeExamples[index];
                    final isSelected = index == _selectedIndex;

                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFF0366d6)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? const Color(0xFF0366d6)
                                        : (isDark
                                            ? Colors.grey[700]!
                                            : Colors.grey[300]!),
                              ),
                            ),
                            child: Text(
                              example['title']!,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : (isDark
                                            ? Colors.grey[300]
                                            : Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Code preview area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CodePreviewWidget(
                    code: _codeExamples[_selectedIndex]['code']!,
                    language: _codeExamples[_selectedIndex]['language']!,
                    showLineNumbers: false,
                    showCopyButton: true,
                    showLanguageLabel: true,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
