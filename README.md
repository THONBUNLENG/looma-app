# Looma Shopping App 🛍️

A modern and feature-rich E-commerce application built with Flutter.

![Looma Banner](assets/image/bg3.png)

## 🌟 Features

- **Multi-language Support**: Fully localized in English and Khmer.
- **Dynamic Theming**: Support for Light and Dark modes.
- **State Management**: Robust state management using the **BLoC** pattern.
- **Firebase Integration**: Powered by Firebase Core, Cloud Firestore, and Firebase Storage.
- **Authentication**: 
  - Secure login with OTP support.
  - Social Auth: Google, Apple, and Facebook sign-in.
  - Session management via `shared_preferences` and `flutter_secure_storage`.
- **Payments & Billing**:
  - Integrated **ABA PayWay** and **Bakong (KHQR)** for seamless transactions.
  - Receipt generation and gallery saving support.
- **Maps & Location**: Integrated Google Maps with geolocator for address and location services.
- **Telegram Integration**: Built-in Telegram bot support via Televerse.
- **Rich UI/UX**:
  - Smooth animations with Lottie.
  - SVG support for crisp icons.
  - Cached network images and video player integration.
  - Haptic feedback and interactive UI components.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (SDK ^3.10.3)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Backend**: [Firebase](https://firebase.google.com/) (Auth, Firestore, Storage)
- **Payments**: `khqr_sdk`, `aba_payway_service` (Custom)
- **Networking**: [Dio](https://pub.dev/packages/dio), [http](https://pub.dev/packages/http)
- **Local Storage**: `shared_preferences`, `flutter_secure_storage`
- **Other Key Packages**: `televerse`, `google_maps_flutter`, `geolocator`, `pinput`, `image_picker`

## 📁 Project Structure

```text
lib/
├── main.dart             # Entry point & App Configuration
├── manager/              # Logic for Cart, Profile, Wishlist, etc.
├── constants/            # App constants, Colors, and Extensions
├── localization/         # Language translation files (EN, KM)
├── light_dark_theme/     # Comprehensive Theme configuration
└── src/
    ├── logic/            # BLoC state management
    ├── model/            # Data models
    ├── screen/           # UI Screens (Home, Main, Login, Splash)
    ├── widget/           # Reusable UI components
    ├── network/          # API, Firestore, & Payment services
    └── telegarm_bot/     # Telegram integration logic
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: `^3.10.3`
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
- **គាំទ្រច្រើនភាសា**: អង់គ្លេស និង ខ្មែរ។
- **មុខងារពន្លឺ (Dark/Light Mode)**: អាចប្ដូរតាមតម្រូវការ។
- **ការទូទាត់ប្រាក់**: បញ្ចូលជាមួយ ABA PayWay និង Bakong (KHQR)។
- **ការចូលប្រើប្រាស់**: គាំទ្រ Google, Apple, Facebook និង លេខទូរស័ព្ទ (OTP)។
- **ទីតាំង**: មានបញ្ចូលជាមួយ Google Maps។
- **សុវត្ថិភាព**: ការពារដោយការប្រើប្រាស់ Secure Storage។
- **តេឡេក្រាម**: មានបញ្ចូលជាមួយ Telegram Bot។
