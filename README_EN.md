# MatchBook (姻缘册)

> 🚩 **Project Status: Archived**  
> This project was originally created to meet a friend's specific needs and for Flutter practice. With mature alternatives available, it is now officially unmaintained.

<div align="center">

<img src="img/app.png" width="200"/>

A professional matchmaker client management system built with Flutter, helping matchmakers efficiently manage and query client information.

[![中文文档](https://img.shields.io/badge/docs-中文-blue.svg)](README.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2+-0175C2?logo=dart)](https://dart.dev)
[![Version](https://img.shields.io/badge/Version-1.1.1-green.svg)](https://github.com/MiQieR/MatchBook)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey.svg)](https://flutter.dev)
[![Database](https://img.shields.io/badge/Database-SQLite-003B57?logo=sqlite)](https://www.sqlite.org)
[![State Management](https://img.shields.io/badge/State-Provider-orange)](https://pub.dev/packages/provider)

</div>

## 📱 Features

### Core Functionality

- **Client Information Entry**
  - Support for manual input of 17 client fields
  - 🎯 One-Click Recognition: Intelligently parses unstructured text and auto-fills forms
  - Safe clipboard paste (handles WeChat rich text)
  - Input validation with warning prompts (red=error, orange=warning)
  - Responsive layout (portrait/landscape adaptive)

- **Advanced Search**
  - Unified keyword search bar
  - Advanced filter panel (expandable/collapsible)
  - Dual search modes:
    - Fuzzy Search (OR logic): Matches any criteria
    - Precise Search (AND logic): Matches all criteria
  - Multi-dimensional filters: gender, age/birth year, height, weight, education, occupation, residence, marital status, car/house ownership
  - Card-based display with grid/list view support

- **Client Management**
  - View complete client profiles
  - Edit existing client information
  - Delete clients (with confirmation dialog)
  - Responsive detail pages

- **Data Management**
  - 📤 Export: Export all client data to JSON format (with timestamp)
  - 📥 Import: Restore data from JSON files
  - Conflict Resolution: Visual interface for choosing versions when client IDs conflict

- **Theme Customization**
  - Light mode
  - Dark mode
  - Follow system
  - Persistent user preferences

### Data Fields

Each client contains the following information:
- Client ID (unique identifier)
- Recommender
- Gender (Male/Female)
- Birth Year
- Birthplace
- Residence
- Height (cm)
- Weight (jin/斤)
- Education (Junior High/High School/Technical/Associate/Bachelor/Master/PhD/Postdoc)
- Occupation
- Family Situation
- Annual Income
- Car
- House
- Marital Status (Single/Short Marriage No Children/Divorced/Widowed/Other)
- Children Information
- Self Evaluation
- Partner Requirements

## 🛠 Tech Stack

### Framework & Language
- **Flutter** (SDK ^3.9.2) - Cross-platform UI framework
- **Dart** - Programming language
- **Material Design 3** - UI design specification

### Core Dependencies
- **drift** (^2.28.1) - SQLite ORM database framework
- **drift_flutter** (^0.2.6) - Flutter adapter
- **sqlite3_flutter_libs** (^0.5.39) - SQLite native libraries
- **provider** (^6.1.2) - State management
- **file_picker** (^8.1.6) - File picker (import/export)
- **url_launcher** (^6.3.1) - Launch external links
- **path_provider** (^2.1.5) - File path management
- **cupertino_icons** (^1.0.8) - iOS style icons

### Development Tools
- **build_runner** (^2.7.2) - Code generation
- **drift_dev** (^2.28.2) - Drift code generator
- **flutter_lints** (^5.0.0) - Code linting
- **flutter_launcher_icons** (^0.14.2) - App icon generation

### Architecture Highlights
- **Local Database**: Drift + SQLite for offline data persistence
- **Responsive Design**: Adaptive to different screen sizes and orientations
- **State Management**: Provider pattern
- **Smart Text Parsing**: Regex-based unstructured text recognition
- **Modular Architecture**: Clear separation of pages, models, and utilities

## 🚀 Development Setup

### Prerequisites

1. **Install Flutter SDK**
   - Required version: >=3.9.2
   - Download: https://flutter.dev/docs/get-started/install

2. **Install IDE (choose one)**
   - Android Studio (recommended) + Flutter plugin
   - VS Code + Flutter extension

3. **Configure Development Environment**
   ```bash
   # Check Flutter environment
   flutter doctor

   # Ensure all checks pass (Android/iOS as needed)
   ```

### Clone Project

```bash
git clone <repository-url>
cd MatchBook
```

### Install Dependencies

```bash
# Get all dependencies
flutter pub get

# Generate Drift database code
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run Project

```bash
# View available devices
flutter devices

# Run on specified device (Debug mode)
flutter run

# Run on Android
flutter run -d android

# Run on iOS (requires macOS)
flutter run -d ios

# Run on Chrome (Web)
flutter run -d chrome
```

## 📦 Build & Release

### Android APK

```bash
# Build release APK
flutter build apk --release

# Build split APKs per architecture (smaller size)
flutter build apk --split-per-abi

# Output location: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (AAB)

```bash
# Build AAB (recommended format for Google Play)
flutter build appbundle --release

# Output location: build/app/outputs/bundle/release/app-release.aab
```

### iOS (requires macOS + Xcode)

```bash
# Build iOS app
flutter build ios --release

# Open project in Xcode for signing and publishing
open ios/Runner.xcworkspace
```

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point
├── database/
│   ├── database.dart              # Drift database instance
│   ├── client.dart                # Data models and enums
│   └── database.g.dart            # Generated database code
├── pages/
│   ├── input_page.dart            # Client input page
│   ├── search_page.dart           # Search/query page
│   ├── settings_page.dart         # Settings page
│   ├── client_detail_page.dart    # Client detail page
│   ├── client_edit_page.dart      # Client edit page
│   └── about_page.dart            # About page
├── widgets/
│   ├── modern_card.dart           # Custom card widget
│   └── gradient_button.dart       # Gradient button widget
└── utils/
    ├── text_parser.dart           # Smart text parser
    ├── theme_provider.dart        # Theme state management
    ├── clipboard_helper.dart      # Clipboard utility
    └── plain_text_formatter.dart  # Text formatter
```

## 🎨 Design Specifications

- **Primary Color**: China Red (#D0021B)
- **Secondary Color**: Coral Red (#F75C5C)
- **Tertiary Color**: Rouge Red (#C41E3A)
- **Border Radius**: 12-24px
- **Layout**: Card-based design with gradient effects
- **Font**: System default font

## 📝 User Guide

### Adding Clients

1. Tap "Add Client" in bottom navigation
2. Two input methods:
   - **Manual Input**: Fill out form field by field
   - **One-Click Recognition**: Paste or enter unstructured text, tap "One-Click Recognition" for automatic parsing

### Querying Clients

1. Tap "Query Clients" in bottom navigation
2. Use keyword search or advanced filters
3. Select search mode:
   - Fuzzy Search: Match any criteria
   - Precise Search: Match all criteria
4. Tap client card to view details

### Export/Import Data

1. Go to "Settings" page
2. Data Management section:
   - **Export**: Choose save location to generate JSON file
   - **Import**: Select JSON file to automatically import data
   - If conflicts exist, system prompts to choose which version to keep

## 📄 License

MIT © MiQieR
