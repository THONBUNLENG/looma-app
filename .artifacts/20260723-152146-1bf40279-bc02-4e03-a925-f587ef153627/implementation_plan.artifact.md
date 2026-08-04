# Add Save (Apply) Button to Address Screen

The goal is to add a "Save" (or "Apply") button at the bottom of the `AddressScreen` to allow users to confirm their address selection. Currently, the screen only has an "Add New Address" button, and users must use the back button to return after selecting a default address.

## User Review Required

- **Button Text**: I have used "Apply" as the primary button text, which is standard for selection screens in e-commerce. However, since you mentioned "save", we can change it to "Save" if you prefer.
- **Button Placement**: The "Apply" button will be the primary action at the bottom, and "Add New Address" will be moved just above it or below it. I've placed "Apply" as the main black button at the bottom.

## Proposed Changes

### Address Feature

#### [address_screen.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/address/address_screen.dart)

- Refactor `_buildAddButton` to `_buildBottomNavigationBar` to include both an "Apply" button and an "Add New Address" button.
- The "Apply" button will call `Navigator.pop(context)` to return to the previous screen (e.g., Order Confirmation) after a selection has been made.
- Update `ListView` padding to accommodate the taller bottom bar.

```dart
  Widget _buildBottomNavigationBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121212) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyCustomButton(
            text: 'Apply'.tr,
            onPressed: () => Navigator.pop(context),
            width: double.infinity,
            height: 56,
            borderRadius: 30,
          ),
          const SizedBox(height: 12),
          MyCustomButton(
            text: 'Add New Address'.tr,
            onPressed: () async {
              // ... existing Add New Address logic
            },
            width: double.infinity,
            height: 56,
            borderRadius: 30,
            // Use different style for secondary button if needed
            gradientColors: isDark ? [Colors.white10, Colors.white10] : [Colors.grey[200]!, Colors.grey[200]!],
            textColor: isDark ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }
```

## Verification Plan

### Automated Tests
- No automated tests available for this UI change.

### Manual Verification
1. Navigate to **Profile** -> **Address**.
2. Verify that two buttons are visible at the bottom: "Apply" and "Add New Address".
3. Select an address (tap on it) and verify it becomes the default.
4. Click "Apply" and verify it returns to the previous screen.
5. Click "Add New Address" and verify it opens the map to add a new address.
6. Verify the UI looks good in both Light and Dark modes.
