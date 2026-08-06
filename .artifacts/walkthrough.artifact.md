# Order BLoC Implementation Walkthrough

I have implemented the `OrderBloc` to handle order-related operations, specifically order placement, replacing the manual logic previously in the UI.

## Changes

### Order BLoC Component

- **[order_event.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/order/bloc/order_event.dart)**: Added `PlaceOrder` and `FetchOrders` events.
- **[order_state.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/order/bloc/order_state.dart)**: Defined `OrderInitial`, `OrderLoading`, `OrderSuccess`, and `OrderFailure` states.
- **[order_bloc.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/order/bloc/order_bloc.dart)**: Implemented the logic to handle `PlaceOrder` using `FirestoreService`.

### UI Integration

- **[order_confirm_screen.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/order/order_confirm_screen.dart)**:
    - Wrapped the UI in `BlocProvider`, `BlocListener`, and `BlocBuilder`.
    - Refactored `_placeOrder` to dispatch the `PlaceOrder` event.
    - Handled navigation and error messages based on BLoC states.
    - Removed `_isOrdering` local state and manual Firestore calls from the screen.

## Verification Summary

### Automated Tests
- Ran `analyze_file` on `order_bloc.dart` and `order_confirm_screen.dart`. No errors or warnings were found.

### Manual Verification (Expected behavior)
1. **Order Placement**:
   - Tapping "Order Now" triggers `OrderLoading`, showing the overlay.
   - Upon successful creation in Firestore, `OrderSuccess` is emitted.
   - The UI responds by clearing the cart and navigating to either `CheckoutPaymentScreen` (for bank transfer) or `OrderSuccessScreen`.
2. **Error Handling**:
   - If Firestore fails, `OrderFailure` is emitted, showing a snackbar with the error message.
