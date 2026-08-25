# Looma Shopping App 🛍️

A modern, feature-rich e-commerce application built with Flutter.

![Looma Banner](assets/image/bg3.png)

## 🌟 Features

- **Multi-language Support** — Fully localized in **English**, **Khmer**, and **Chinese**.
- **Dynamic Theming** — Light and Dark mode support.
- **AI Customer Support** — Integrated **Gemini AI** (via Firebase AI) for automated customer assistance and Telegram bot support.
- **Push Notifications** — Integrated with **OneSignal** and **Firebase Messaging** for real-time updates.
- **Birthday Reward System** — Custom birthday celebration dialog with reward vouchers ($25 Cash Vouchers).
- **State Management** — Robust state management using the **BLoC** pattern (`flutter_bloc`).
- **Firebase Integration** — Powered by Firebase Core, Cloud Firestore, Firebase Storage, and Firebase Auth.
- **Authentication**
  - Secure login with **OTP support** (Pinput).
  - Social auth: **Google**, **Apple**, and **Facebook** sign-in.
  - Email/password login with password recovery.
  - Session management via `shared_preferences` and `flutter_secure_storage`.
- **Payments & Billing**
  - Integrated **ABA PayWay** and **Bakong (KHQR)** for seamless transactions.
  - Receipt generation and gallery-saving support.
- **Maps & Location** — Google Maps integration with Geolocator for address and location services.
- **Rich UI/UX**
  - Smooth animations with **Lottie**.
  - SVG support for crisp icons.
  - Cached network images and video player integration.
  - Haptic feedback and interactive UI components.

## 🛠️ Tech Stack

 Category | Packages / Tools |
---|---|
 Framework | [Flutter](https://flutter.dev) (SDK `^3.10.3`) |
 State Management | [flutter_bloc](https://pub.dev/packages/flutter_bloc) (`^9.1.1`) |
 AI Integration | `firebase_ai` (Gemini AI) |
 Backend | [Firebase](https://firebase.google.com/) (Auth, Firestore, Storage, Messaging) |
 Push Notifications | `onesignal_flutter`, `firebase_messaging` |
 Payments | `khqr_sdk`, `aba_payway_service` (custom) |
 Networking | [Dio](https://pub.dev/packages/dio), [http](https://pub.dev/packages/http) |
 Local Storage | `shared_preferences`, `flutter_secure_storage` |
 Other Key Packages | `televerse`, `google_maps_flutter`, `geolocator`, `pinput`, `image_picker`, `mobile_scanner`, `gal` |

## 📁 Project Structure

```text
lib/
├── main.dart             # Entry point & app configuration
├── manager/              # Logic for Cart, Profile, Wishlist, Notifications, etc.
├── constants/            # App constants, colors, and navigator extensions
├── localization/         # Language translation files (EN, KM, CN)
├── light_dark_theme/     # Comprehensive theme configuration
└── src/
    ├── logic/            # BLoC state management
    ├── model/            # Data models (Order, Product, User, etc.)
    ├── screen/           # UI screens (Home, Profile, Splash, Wallet, Flash Sale)
    ├── widget/           # Reusable UI components (Birthday Dialog, Vouchers)
    ├── network/          # API, Firestore, and payment services
    ├── utils/            # Shared utilities and helpers
    └── telegarm_bot/     # Telegram integration & AI logic (Note: Typo in folder name)
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.10.3`
- Android Studio or VS Code with the Flutter/Dart plugins
- A configured Firebase project (Auth, Firestore, Storage, AI enabled)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/looma-shopping-app.git
   ```
2. Navigate to the project directory:
   ```bash
   cd looma-shopping-app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Add your Firebase configuration files:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
5. Run the app:
   ```bash
   flutter run
   ```

## 🔑 Environment Configuration

Create a `.env` file (or use your preferred secrets manager) with the keys required by the app, for example:

```env
TELEGRAM_BOT_TOKEN=your_telegram_bot_token
ABA_PAYWAY_MERCHANT_ID=your_merchant_id
GOOGLE_MAPS_API_KEY=your_google_maps_key
ONESIGNAL_APP_ID=your_onesignal_app_id
```

> ⚠️ Never commit real API keys or secrets to version control.

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature`.
3. Commit your changes: `git commit -m "Add your feature"`.
4. Push to the branch: `git push origin feature/your-feature`.
5. Open a Pull Request.

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## 🇰🇭 ការពិពណ៌នាគម្រោង (Khmer)

កម្មវិធីទិញទំនិញទំនើបដែលបង្កើតឡើងដោយប្រើប្រាស់ Flutter ជាមួយនឹងមុខងារពេញលេញ៖

- **គាំទ្រច្រើនភាសា**: អង់គ្លេស ខ្មែរ និងចិន។
- **ជំនួយការ AI**: បញ្ចូលជាមួយ AI Assistant Support (Gemini AI) ក្នុងកម្មវិធី និងតាមរយៈ Telegram Bot។
- **ប្រព័ន្ធរង្វាន់ថ្ងៃកំណើត**: កម្មវិធីផ្ដល់រង្វាន់ Cash Voucher $25 ក្នុងថ្ងៃកំណើត។
- **ការជូនដំណឹង (Push Notifications)**: ប្រើប្រាស់ OneSignal និង Firebase Messaging។
- **មុខងារពន្លឺ (Dark/Light Mode)**: អាចប្ដូរតាមតម្រូវការ។
- **ការទូទាត់ប្រាក់**: បញ្ចូលជាមួយ ABA PayWay និង Bakong (KHQR)។
- **ការចូលប្រើប្រាស់**: គាំទ្រ Google, Apple, Facebook, អ៊ីមែល និងលេខទូរស័ព្ទ (OTP)។
- **ទីតាំង**: មានបញ្ចូលជាមួយ Google Maps។
- **សុវត្ថិភាព**: ការពារដោយការប្រើប្រាស់ Secure Storage។
- **តេឡេក្រាម**: មានបញ្ចូលជាមួយ Telegram Bot សម្រាប់ការជូនដំណឹងការបញ្ជាទិញ។
