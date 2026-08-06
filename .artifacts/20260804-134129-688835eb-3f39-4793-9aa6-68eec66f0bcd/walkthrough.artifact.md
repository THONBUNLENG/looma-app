# Walkthrough: Fix Order Confirmation Button UI & Khmer Text

I have fixed the "Order Now" button in the "Order Confirm" screen. The button was previously obscured by the system navigation bar and truncated the Khmer text.

## Changes Made

### Order Component

#### [order_confirm_screen.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/order/order_confirm_screen.dart)

- **Fixed Obscured Button**: Wrapped the bottom bar in a `SafeArea` (setting `top: false`) to ensure it stays above the device's home indicator.
- **Fixed Khmer Text Truncation**:
    - Increased the button height from **50 to 56**. Khmer script (like "បញ្ជាទិញឥឡូវនេះ") has tall glyphs that need more vertical space.
    - Wrapped the button text in a `FittedBox` with `BoxFit.scaleDown`. This automatically adjusts the font size if the Khmer text is too wide for the button, preventing it from being cut off.
- **Improved Layout**: Replaced the fixed-width `SizedBox` with `Expanded` so the button utilizes the remaining screen width properly.

## Verification Summary

- **Static Analysis**: Ran `analyze_file` on [order_confirm_screen.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/order/order_confirm_screen.dart) and no errors or warnings were found.
- **Visual Logic**: These changes directly address the clipping and truncation issues seen in the screenshots by providing more space and flexible scaling.
