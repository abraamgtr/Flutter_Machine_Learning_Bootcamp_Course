# 🎯 CodeMuse Code Assistant

A professional Flutter application that provides intelligent code generation with beautiful syntax highlighting, VS Code-like features, and a modern UI. Built with advanced architecture patterns and cutting-edge Flutter technologies.

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Material Design](https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=material-design&logoColor=white)

*Professional code generation with beautiful syntax highlighting*

</div>

## ✨ Features

### 🎨 **Professional Syntax Highlighting**
- **VS Code-like Interface**: Professional code preview with language headers
- **10 Beautiful IDE Themes**: GitHub Enhanced, Atom One Dark, Dracula, Monokai Pro, and more
- **50+ Programming Languages**: Comprehensive language detection with 100+ patterns
- **Important Parts Highlighting**: Enhanced emphasis on functions, classes, and keywords
- **JetBrains Mono Font**: Optimized typography for code readability

### ⚙️ **Advanced Settings Management**
- **Persistent Settings**: SharedPreferences integration for theme and preference storage
- **Theme Synchronization**: Selected themes persist across app restarts
- **Live Preview**: Real-time code preview showing selected theme in action
- **Accessibility Options**: Font size adjustment and display preferences
- **Minimal Design**: Clean, developer-focused settings interface

### 🚀 **Modern User Experience**
- **Material 3 Design**: Latest Material Design principles
- **Smooth Animations**: 60fps animations and micro-interactions
- **Responsive Layout**: Optimized for mobile, tablet, and desktop
- **Dark/Light Themes**: System-aware theme switching
- **Professional Typography**: Google Fonts integration

### 🏗️ **Clean Architecture**
- **Dependency Injection**: GetIt service locator pattern
- **Provider State Management**: Reactive state management
- **Repository Pattern**: Clean data layer separation
- **Use Cases**: Business logic encapsulation
- **Service Layer**: Modular service architecture

## 🛠️ Tech Stack

### **Frontend**
- **Flutter 3.7+**: Latest stable Flutter framework
- **Material 3**: Modern design system
- **Provider**: State management solution
- **Google Fonts**: Beautiful typography
- **Animations**: Custom animation controllers

### **Syntax Highlighting**
- **re_highlight**: Advanced syntax highlighting engine
- **190+ Languages**: Comprehensive language support
- **Custom Themes**: Professional IDE-inspired color schemes
- **Pattern Recognition**: Intelligent language detection

### **Storage & Persistence**
- **SharedPreferences**: Local settings storage
- **History Management**: Generation history tracking
- **Theme Persistence**: User preference memory

### **Architecture**
- **Clean Architecture**: Robert Martin's clean architecture
- **SOLID Principles**: Maintainable and scalable code
- **Dependency Injection**: Loosely coupled components
- **Service Locator**: Centralized dependency management

## 📱 Screenshots

### Code Generation & Highlighting
```dart
class CodeAssistant {
  final String theme;
  
  String generateCode(String prompt) {
    return "Beautiful ${theme} theme!";
  }
}
```

### Available IDE Themes

| Theme | Description | Style |
|-------|-------------|-------|
| 🐙 **GitHub Enhanced** | Clean professional light theme | Light |
| 🌙 **Atom One Dark Enhanced** | Popular dark theme from Atom | Dark |
| 🧛 **Dracula Beautiful** | Dark theme with vibrant colors | Dark |
| 🎨 **Monokai Pro** | Modern take on classic Monokai | Dark |
| 🌊 **Oceanic Next** | Calm oceanic color palette | Dark |
| ❄️ **Nord Theme** | Arctic-inspired minimal design | Dark |
| 🌃 **Tokyo Night** | Clean Tokyo-inspired theme | Dark |
| 🍂 **Gruvbox Dark** | Retro groove color scheme | Dark |
| 🌟 **Synthwave '84** | Retro-futuristic neon theme | Dark |
| 🎯 **Material Theme** | Google Material Design inspired | Dark |

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: Version 3.7.2 or higher
- **Dart SDK**: Version 3.0.0 or higher
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Platform**: iOS, Android, macOS, Windows, Linux, or Web

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/deepseek_code_assist.git
   cd deepseek_code_assist
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your API configuration
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# macOS
flutter build macos --release

# Windows
flutter build windows --release

# Web
flutter build web --release
```

## 🎯 Usage

### Basic Code Generation

1. **Open the app** and navigate to the main screen
2. **Enter your prompt** in the input field
3. **Tap "Generate"** to create code
4. **View results** with beautiful syntax highlighting
5. **Copy or share** the generated code

### Settings & Themes

1. **Open Settings** from the navigation drawer
2. **Choose your preferred IDE theme** from 10 available options
3. **Adjust font size** and display preferences
4. **Settings automatically save** and persist across restarts

### History Management

1. **View generation history** from the drawer
2. **Tap any item** to view in full-screen IDE preview
3. **Search through history** to find previous generations
4. **Clear history** when needed

## 🏗️ Architecture Overview

```
lib/
├── 📁 core/                    # Core utilities and constants
│   ├── 📁 constants/           # App-wide constants
│   ├── 📁 di/                  # Dependency injection setup
│   ├── 📁 error/               # Error handling
│   └── 📁 utils/               # Utility functions
├── 📁 data/                    # Data layer
│   ├── 📁 datasources/         # Remote and local data sources
│   ├── 📁 models/              # Data models
│   └── 📁 repositories/        # Repository implementations
├── 📁 domain/                  # Business logic layer
│   ├── 📁 entities/            # Domain entities
│   ├── 📁 repositories/        # Repository interfaces
│   └── 📁 usecases/            # Business use cases
├── 📁 infrastructure/          # Infrastructure services
│   └── 📁 services/            # App services (theme, highlighting, etc.)
└── 📁 presentation/            # UI layer
    ├── 📁 pages/               # App screens
    ├── 📁 providers/           # State management
    └── 📁 widgets/             # Reusable UI components
```

## 🎨 Customization

### Adding New Themes

1. **Define theme colors** in `SyntaxHighlightingService`
2. **Add theme configuration** to the themes map
3. **Include preview colors** for the settings page
4. **Register theme** in available themes list

### Language Support

The app supports **50+ programming languages** including:

- **Mobile**: Dart, Flutter, Swift, Kotlin, Java
- **Web**: JavaScript, TypeScript, HTML, CSS, React, Vue
- **Backend**: Python, Node.js, Go, Rust, Java, C#
- **Data**: SQL, MongoDB, PostgreSQL, Redis
- **DevOps**: Docker, YAML, JSON, Shell scripts
- **And many more...**

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'feat(feature): add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Git Commit Convention

We use conventional commits:

```
feat(scope): add new feature
fix(scope): fix bug
docs(scope): update documentation
style(scope): formatting changes
refactor(scope): code refactoring
test(scope): add or update tests
chore(scope): maintenance tasks
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Material Design** for the beautiful design system
- **re_highlight** for the powerful syntax highlighting
- **Open Source Community** for inspiration and libraries

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/your-username/deepseek_code_assist/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/deepseek_code_assist/discussions)
- **Email**: your-email@example.com

---

<div align="center">

**Built with ❤️ using Flutter**

*Professional code generation with beautiful syntax highlighting*

</div>
