# Telegram Bot & Order Notification Implementation Plan

This plan integrates a Telegram Bot for both **Order Notifications** and **AI Customer Support (Gemini)**.

## User Review Required

> [!IMPORTANT]
> **API Keys**:
> - Telegram Bot Token: `8752422469:AAEaAtUqs3zJmu-McbPGvxYofBeKwSc11ZI`
> - Gemini API Key: **Please provide your Gemini API key** (I will use a placeholder for now).
> **New Dependency**: `google_generative_ai` will be added to `pubspec.yaml`.

## Proposed Changes

### [Telegram Bot Component]

#### [bot_manager.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/telegarm_bot/bot_manager.dart)
- Integrate `GenerativeModel` from `google_generative_ai`.
- Update `start()` to:
    - Handle `/start` and `/register` (to save the Group ID to Firestore).
    - Use Gemini to answer customer questions using the Looma Knowledge Base.
    - Briefly instruct users to contact support if Gemini cannot answer.
- Update `sendOrderNotification()` to send rich markdown messages to the registered Group ID.

#### [firestore_service.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/network/crud_firebase/firestore_service.dart)
- Add `getTelegramAdminChatId()` and `saveTelegramAdminChatId(int chatId)` to share the registration across all users.

---

### [Application Startup]

#### [main.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/main.dart)
- Ensure `BotManager().start()` is called at launch.

---

### [Dependencies]

#### [pubspec.yaml](file:///C:/Users/ASUS/Documents/looma-app/pubspec.yaml)
- Add `google_generative_ai: ^0.4.0`

## Verification Plan

### Manual Verification
1. **AI Chat**: Send "What are your business hours?" to the bot and verify the Gemini response.
2. **Registration**: Send `/register` in the "Looma Support" group.
3. **Orders**: Place an order in the app and verify the notification appears in the "Looma Support" group.
