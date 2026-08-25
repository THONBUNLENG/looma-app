# Telegram Bot and AI Support Improvements

This plan aims to refactor the `BotManager` class to improve maintainability, security, and AI response quality. It also fixes a directory naming typo and enhances the customer support knowledge base.

## User Review Required

> [!IMPORTANT]
> The Telegram Bot Token is currently hardcoded. While I will move it to a cleaner constant, consider moving it to an environment variable or Firebase Remote Config in the future for better security.

## Proposed Changes

### Core & Infrastructure

#### [NEW] [telegram_bot/](file:///C:/Users/ASUS/Documents/looma-app/lib/src/telegram_bot/)

- Rename directory from `telegarm_bot` to `telegram_bot`.
- Update all imports in `main.dart`, `firestore_service.dart`, and `ai_chat_screen.dart`.

#### [bot_manager.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/telegram_bot/bot_manager.dart)

- **Consolidate AI Logic**: Create a private `_generateAiResponse` method to handle content generation and error catching for both Telegram messages and in-app chat.
- **Improve `sendOrderNotification`**:
    - Fetch customer details (name, phone) from Firestore using the `userId` from the order.
    - Use the existing `_bot` instance if it's already running to avoid creating multiple instances.
    - Enhance markdown formatting for better readability on Telegram.
- **Secure Token**: Move the token to a static constant `_botToken`.
- **Group Chat Awareness**: Update `onMessage` to only respond in private chats or when the bot is mentioned (optional, but recommended for support groups).

#### [NEW] [bot_constants.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/telegram_bot/bot_constants.dart)

- Move the long system instruction string to this file for better readability and maintainability.
- **Enhanced System Instruction**:
    - Add explicit instructions to support both English and Khmer.
    - Include detailed knowledge about the membership levels (Silver, Gold, Platinum).
    - Include details about point redemption (17 points = $5 coupon, 1 point per $10 purchase).
    - Include information about souvenir redemption and birthday rewards.

---

### UI & Integration

#### [ai_chat_screen.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/profile_screen/ai_chat_screen.dart)

- Update import path to `telegram_bot`.

#### [firestore_service.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/network/crud_firebase/firestore_service.dart)

- Update import path to `telegram_bot`.

#### [main.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/main.dart)

- Update import path to `telegram_bot`.

## Verification Plan

### Automated Tests
- Run `lib/src/telegram_bot/test_telegram.dart` to verify order notifications with the new formatting.

### Manual Verification
- **Telegram Bot**: Message the bot in a private chat to verify AI responses in both English and Khmer.
- **In-App AI Chat**: Open the AI Support screen in the app and send a query to verify it still works correctly after refactoring.
- **Order Notification**: Place a test order (if possible) or trigger a notification manually via a script to ensure customer details are correctly fetched and displayed.
