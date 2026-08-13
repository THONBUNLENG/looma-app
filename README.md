# Looma Shopping App 🛍️

A modern, feature-rich e-commerce application built with Flutter.

![Looma Banner](assets/image/bg3.png)

## 🌟 Features

- **Multi-language Support** — Fully localized in English and Khmer.
- **Dynamic Theming** — Light and Dark mode support.
- **AI Customer Support** — Integrated **Gemini AI** via a Telegram bot for automated FAQ responses.
- **Birthday Reward System** — Custom birthday celebration dialog with reward vouchers.
- **State Management** — Robust state management using the **BLoC** pattern.
- **Firebase Integration** — Powered by Firebase Core, Cloud Firestore, and Firebase Storage.
- **Authentication**
  - Secure login with OTP support.
  - Social auth: Google, Apple, and Facebook sign-in.
  - Email/password login with password recovery.
  - Session management via `shared_preferences` and `flutter_secure_storage`.
- **Payments & Billing**
  - Integrated **ABA PayWay** and **Bakong (KHQR)** for seamless transactions.
  - Receipt generation and gallery-saving support.
- **Maps & Location** — Google Maps integration with Geolocator for address and location services.
- **Telegram Integration** — Built-in Telegram bot support via Televerse.
- **Rich UI/UX**
  - Smooth animations with Lottie.
  - SVG support for crisp icons.
  - Cached network images and video player integration.
  - Haptic feedback and interactive UI components.

## 🛠️ Tech Stack

| Category | Packages / Tools |
|---|---|
| Framework | [Flutter](https://flutter.dev) (SDK `^3.10.3`) |
| State Management | [flutter_bloc](https://pub.dev/packages/flutter_bloc) |
| AI Integration | [google_generative_ai](https://pub.dev/packages/google_generative_ai) |
| Backend | [Firebase](https://firebase.google.com/) (Auth, Firestore, Storage) |
| Payments | `khqr_sdk`, `aba_payway_service` (custom) |
| Networking | [Dio](https://pub.dev/packages/dio), [http](https://pub.dev/packages/http) |
| Local Storage | `shared_preferences`, `flutter_secure_storage` |
| Other Key Packages | `televerse`, `google_maps_flutter`, `geolocator`, `pinput`, `image_picker`, `mobile_scanner` |

## 📁 Project Structure

```text
lib/
├── main.dart             # Entry point & app configuration
├── manager/              # Logic for Cart, Profile, Wishlist, etc.
├── constants/            # App constants, colors, and extensions
├── localization/         # Language translation files (EN, KM)
├── light_dark_theme/     # Comprehensive theme configuration
└── src/
    ├── logic/            # BLoC state management
    ├── model/            # Data models
    ├── screen/           # UI screens (Home, Main, Login, Splash, Wallet, Flash Sale)
    ├── widget/           # Reusable UI components (Birthday Dialog, Vouchers)
    ├── network/          # API, Firestore, and payment services
    └── telegram_bot/     # Telegram integration & AI logic
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.10.3`
- Android Studio or VS Code with the Flutter/Dart plugins
- A configured Firebase project (Auth, Firestore, Storage enabled)

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
GEMINI_API_KEY=your_gemini_api_key
TELEGRAM_BOT_TOKEN=your_telegram_bot_token
ABA_PAYWAY_MERCHANT_ID=your_merchant_id
GOOGLE_MAPS_API_KEY=your_google_maps_key
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

- **គាំទ្រច្រើនភាសា**: អង់គ្លេស និងខ្មែរ។
- **ជំនួយការ AI**: បញ្ចូលជាមួយ Gemini AI តាមរយៈ Telegram Bot។
- **ប្រព័ន្ធរង្វាន់ថ្ងៃកំណើត**: កម្មវិធីផ្ដល់រង្វាន់ Voucher ក្នុងថ្ងៃកំណើត។
- **មុខងារពន្លឺ (Dark/Light Mode)**: អាចប្ដូរតាមតម្រូវការ។
- **ការទូទាត់ប្រាក់**: បញ្ចូលជាមួយ ABA PayWay និង Bakong (KHQR)។
- **ការចូលប្រើប្រាស់**: គាំទ្រ Google, Apple, Facebook, អ៊ីមែល និងលេខទូរស័ព្ទ (OTP)។
- **ទីតាំង**: មានបញ្ចូលជាមួយ Google Maps។
- **សុវត្ថិភាព**: ការពារដោយការប្រើប្រាស់ Secure Storage។
- **តេឡេក្រាម**: មានបញ្ចូលជាមួយ Telegram Bot។
