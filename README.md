# Shopping App 🛍️

A modern and feature-rich E-commerce application built with Flutter.

## 🌟 Features

- **Multi-language Support**: Fully localized in English, Khmer, and Chinese.
- **Dynamic Theming**: Support for Light and Dark modes with automatic system detection.
- **State Management**: Robust state management using the **BLoC** pattern.
- **Firebase Integration**: Powered by Firebase Core and Cloud Firestore for real-time data.
- **Maps & Location**: Integrated Google Maps with geolocator for address and location services.
- **Authentication**: Secure login with OTP support (using Pinput).
- **Network Management**: Efficient API handling using Dio and connectivity monitoring.
- **Rich UI/UX**:
  - Smooth animations with Lottie.
  - SVG support for crisp icons.
  - Cached network images for better performance.
  - Video player integration.
  - Custom dropdowns and image picking capabilities.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Backend**: [Firebase](https://firebase.google.com/)
- **Networking**: [Dio](https://pub.dev/packages/dio)
- **Local Storage**: `shared_preferences`, `flutter_secure_storage`
- **Localization**: `flutter_localization`

## 📁 Project Structure

```text
lib/
├── main.dart             # Entry point
├── manager/              # Preferences and Managers
├── constants/            # App constants and extensions
├── localization/         # Language translation files
├── light_dark_theme/     # Theme configuration
└── src/
    ├── auth/             # Authentication logic
    ├── model/            # Data models
    ├── screen/           # UI Screens
    ├── widget/           # Reusable widgets
    ├── network/          # API & Connectivity
    └── telegram_bot/     # Telegram integration
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: `^3.10.3`
- Dart SDK
- Android Studio / VS Code

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/shopping_app.git
   ```
2. Navigate to the project directory:
   ```bash
   cd shopping_app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## 🇰🇭 ការពិពណ៌នាគម្រោង (Khmer)

កម្មវិធីទិញទំនិញទំនើបដែលបង្កើតឡើងដោយប្រើប្រាស់ Flutter ជាមួយនឹងមុខងារពេញលេញ៖
- **គាំទ្រច្រើនភាសា**: អង់គ្លេស, ខ្មែរ, និង ចិន។
- **មុខងារពន្លឺ (Dark/Light Mode)**: អាចប្ដូរតាមតម្រូវការ ឬតាមប្រព័ន្ធទូរស័ព្ទ។
- **ការគ្រប់គ្រងទិន្នន័យ**: ប្រើប្រាស់ Firebase Firestore។
- **ទីតាំង**: មានបញ្ចូលជាមួយ Google Maps។
- **សុវត្ថិភាព**: ការពារដោយការប្រើប្រាស់ Secure Storage និង OTP។
