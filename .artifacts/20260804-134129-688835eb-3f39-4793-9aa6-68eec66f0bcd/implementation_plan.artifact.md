# Fix UI Button in Order Confirmation Screen

The "Order Now" button in the `OrderConfirmScreen` is appearing too low and is partially obscured by the system navigation bar (home indicator) on modern mobile devices. This is because the bottom bar does not account for the safe area at the bottom of the screen.

## Proposed Changes

### Order Component

#### [order_confirm_screen.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/order/order_confirm_screen.dart)

- Wrap the content of the `_buildBottomBar` method in a `SafeArea` to ensure it respects system UI boundaries.
- Adjust the layout of the "Order Now" button to be more flexible, using `Expanded` instead of a fixed-width `SizedBox` to better accommodate translations (like Khmer) and different screen sizes.

```diff
  Widget _buildBottomBar(bool isDark) {
    return Container(
-     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
-     child: Row(
-       mainAxisAlignment: MainAxisAlignment.spaceBetween,
-       children: [
-         Column(
-           mainAxisSize: MainAxisSize.min,
-           crossAxisAlignment: CrossAxisAlignment.start,
-           children: [
-             TextWidget("Total amount:".tr, fontSize: 12, color: Colors.grey),
-             TextWidget(
-               "${_total.toStringAsFixed(2)} USD",
-               fontSize: 18,
-               fontWeight: FontWeight.bold,
-             ),
-           ],
-         ),
-         SizedBox(
-           width: 180,
-           height: 50,
-           child: ElevatedButton(
-             onPressed: _isOrdering
-                 ? null
-                 : () async {
-                     if (_selectedPayment == 1) {
-                       final tempOrderId = "ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
-                       Navigator.push(
-                         context,
-                         MaterialPageRoute(
-                           builder: (context) => CheckoutPaymentScreen(
-                             totalAmount: _total,
-                             orderId: tempOrderId,
-                           ),
-                         ),
-                       );
-                     } else {
-                       await _placeOrder();
-                     }
-                   },
-             style: ElevatedButton.styleFrom(
-               backgroundColor: AppColor.pink100Color,
-               shape: RoundedRectangleBorder(
-                 borderRadius: BorderRadius.circular(30),
-               ),
-               elevation: 0,
-             ),
-             child: _isOrdering
-                 ? const SizedBox(
-                     width: 20,
-                     height: 20,
-                     child: CircularProgressIndicator(
-                       color: Colors.white,
-                       strokeWidth: 2,
-                     ),
-                   )
-                 : TextWidget(
-                     "Order Now".tr,
-                     color: Colors.white,
-                     fontSize: 16,
-                     fontWeight: FontWeight.bold,
-                   ),
-           ),
-         ),
-       ],
-     ),
+     child: SafeArea(
+       top: false,
+       child: Padding(
+         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
+         child: Row(
+           children: [
+             Column(
+               mainAxisSize: MainAxisSize.min,
+               crossAxisAlignment: CrossAxisAlignment.start,
+               children: [
+                 TextWidget("Total amount:".tr, fontSize: 12, color: Colors.grey),
+                 TextWidget(
+                   "${_total.toStringAsFixed(2)} USD",
+                   fontSize: 18,
+                   fontWeight: FontWeight.bold,
+                 ),
+               ],
+             ),
+             const SizedBox(width: 20),
+             Expanded(
+               child: SizedBox(
+                 height: 50,
+                 child: ElevatedButton(
+                   onPressed: _isOrdering
+                       ? null
+                       : () async {
+                           if (_selectedPayment == 1) {
+                             final tempOrderId = "ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
+                             Navigator.push(
+                               context,
+                               MaterialPageRoute(
+                                 builder: (context) => CheckoutPaymentScreen(
+                                   totalAmount: _total,
+                                   orderId: tempOrderId,
+                                 ),
+                               ),
+                             );
+                           } else {
+                             await _placeOrder();
+                           }
+                         },
+                   style: ElevatedButton.styleFrom(
+                     backgroundColor: AppColor.pink100Color,
+                     shape: RoundedRectangleBorder(
+                       borderRadius: BorderRadius.circular(30),
+                     ),
+                     elevation: 0,
+                   ),
+                   child: _isOrdering
+                       ? const SizedBox(
+                           width: 20,
+                           height: 20,
+                           child: CircularProgressIndicator(
+                             color: Colors.white,
+                             strokeWidth: 2,
+                           ),
+                         )
+                       : TextWidget(
+                           "Order Now".tr,
+                           color: Colors.white,
+                           fontSize: 16,
+                           fontWeight: FontWeight.bold,
+                         ),
+                 ),
+               ),
+             ),
+           ],
+         ),
+       ),
+     ),
    );
  }
```

## Verification Plan

### Automated Tests
- I will run `flutter analyze` to ensure there are no syntax errors or linting issues introduced.

### Manual Verification
- I will use `render_compose_preview` if available, or just rely on the logic that `SafeArea` and `Expanded` are the correct tools for this layout issue.
- Since I don't have a live device to run on, I will verify by reviewing the code structure and ensuring it follows Flutter's best practices for bottom-anchored UI components.
