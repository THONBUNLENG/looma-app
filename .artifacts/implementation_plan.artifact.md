# Fix Order BLoC

The existing `OrderBloc` is largely unimplemented (boilerplate only). This plan outlines implementing the necessary events, states, and BLoC logic to handle order-related operations, starting with order placement.

## Proposed Changes

### Order BLoC Component

Implement the events, states, and logic for the Order BLoC.

#### [order_event.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/order/bloc/order_event.dart)

- Define `PlaceOrder` event that takes an `OrderModel`.
- Define `FetchOrders` event to get user's order history.

#### [order_state.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/order/bloc/order_state.dart)

- Define `OrderLoading`, `OrderSuccess`, and `OrderFailure` states.
- `OrderSuccess` will hold the created order or list of orders.
- `OrderFailure` will hold an error message.

#### [order_bloc.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/order/bloc/order_bloc.dart)

- Implement the event handlers for `PlaceOrder` and `FetchOrders`.
- Use `FirestoreService` to interact with Firebase.

---

### UI Integration

#### [order_confirm_screen.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/order/order_confirm_screen.dart)

- Wrap the screen or specific parts with `BlocProvider` and `BlocListener`/`BlocBuilder`.
- Refactor `_placeOrder` to dispatch the `PlaceOrder` event instead of handling logic internally.

## Verification Plan

### Automated Tests
- Since there are no existing BLoC tests, I will focus on manual verification.

### Manual Verification
1. **Order Placement**:
   - Navigate to the `OrderConfirmScreen`.
   - Fill in details and click "Order Now".
   - Verify that the loading state is shown.
   - Verify that upon success, it navigates to the success screen or payment screen.
   - Verify that the order is actually created in Firestore (by checking the logs or if I had DB access, but here I'll rely on the app flow).
2. **Error Handling**:
   - Mock a failure (e.g., by temporarily changing the collection name in `FirestoreService`) and verify the error snackbar appears.
