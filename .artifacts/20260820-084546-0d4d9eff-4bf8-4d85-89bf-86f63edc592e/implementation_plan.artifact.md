# Fix Product Detail Image Display & Auto-Scroll

The goal is to make the product image in the detail screen more immersive by making it fill the screen width and height more effectively, and to add an automatic image slider that changes every 4 seconds.

## Proposed Changes

### Product Detail Screen

#### [product_detail_screen.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/product_detail/product_detail_screen.dart)

- **Immersive Image Display**:
    - Increase the main image container height to `0.7` of the screen height.
    - Change the `BoxFit` to `BoxFit.cover` so the image fills the entire area without side borders.
    - Remove the `SafeArea` around the back button and cart badge if they should overlap the image at the very top (though usually, `SafeArea` is good for notch handling). Wait, looking at the image, they are already overlapping. I'll just make the container taller.
- **Auto-Scroll (4 seconds)**:
    - Add a `Timer` in `initState` to automatically scroll the `PageView` every 4 seconds.
    - Handle `Timer` cancellation in `dispose`.
    - Ensure manual interaction resets or pauses the timer (optional, but good practice). For now, I'll implement a simple cyclic auto-scroll.

```dart
// In _ProductClothesScreenState
Timer? _timer;

@override
void initState() {
  super.initState();
  // ... existing code ...
  _startTimer();
}

void _startTimer() {
  _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
    if (_pageController.hasClients) {
      int nextPage = (_currentPage + 1) % images.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  });
}

@override
void dispose() {
  _timer?.cancel();
  _pageController.dispose();
  super.dispose();
}
```

## Verification Plan

### Automated Tests
- None.

### Manual Verification
- **Full Width/Height**: Open product detail and verify the image fills the top 70% of the screen with no white sidebars.
- **Auto-Scroll**: Wait for 4 seconds and verify the image changes automatically.
- **Manual Scroll**: Verify you can still swipe manually and it doesn't break anything.
- **Full Image Gallery**: Tap the image and verify you can see the full uncropped image in the gallery.
