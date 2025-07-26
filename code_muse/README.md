# 🎭 CodeMuse - Your AI-Powered Code Generation Assistant 🚀

<div align="center">
  
![CodeMuse Logo](https://img.shields.io/badge/CodeMuse-AI%20Code%20Generation-blue?style=for-the-badge)
[![Flutter](https://img.shields.io/badge/Flutter-3.7+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge)](CONTRIBUTING.md)

</div>

## ✨ Overview

CodeMuse is a powerful Flutter application that leverages AI to generate code snippets based on natural language prompts. Whether you're a beginner looking for code examples or an experienced developer seeking to speed up your workflow, CodeMuse has you covered!

## 🔥 Key Features

- 🤖 **AI-Powered Code Generation** - Transform natural language into functional code
- 🌈 **Syntax Highlighting** - Beautiful code display with proper highlighting
- 📱 **Cross-Platform** - Works on Android, iOS, desktop, and web
- 🔍 **Code Preview** - Review and edit generated code before using it
- 📚 **History Tracking** - Access your previously generated code snippets
- 🌙 **Dark/Light Mode** - Customize your visual experience
- ⚡ **Fast and Responsive** - Optimized for performance

## 📸 Screenshots

<div align="center">
  <i>Screenshots coming soon!</i>
</div>

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.7+
- **State Management**: Provider
- **Dependency Injection**: GetIt
- **HTTP Client**: Dio
- **Environment Variables**: flutter_dotenv
- **Local Storage**: shared_preferences
- **Syntax Highlighting**: re_highlight
- **UI**: Google Fonts, Material Design 3

## 📋 Requirements

- Flutter SDK 3.7.2 or higher
- Dart SDK 3.0.0 or higher
- API key for the AI service (stored in .env file)

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/code_muse.git
cd code_muse
```

### 2. Create environment file

Create a `.env` file in the root directory with your API key:

```
DEEPSEEK_API_KEY=your_api_key_here
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the app

```bash
flutter run
```

## 🏗️ Project Structure

The project follows a clean architecture approach with feature-based organization:

```
lib/
  ├── core/                 # Core functionality and utilities
  │   ├── error/            # Exception handling
  │   ├── services/         # App-wide services
  │   └── utils/            # Utility functions
  │
  ├── features/             # Feature modules
  │   ├── feature_code_review/    # Code preview and review
  │   ├── feature_history/        # History tracking
  │   ├── feature_homepage/       # Main app functionality
  │   └── feature_settings/       # App settings
  │
  ├── injection_container.dart    # Dependency injection setup
  └── main.dart                   # App entry point
```

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All the contributors who have helped shape this project

---

<div align="center">
  
  **Built with ❤️ by developers, for developers**
  
</div>

