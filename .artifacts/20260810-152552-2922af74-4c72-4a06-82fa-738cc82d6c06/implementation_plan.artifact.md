# Fix Imports in membership_qr_screen.dart

Clean up and unify the imports in `membership_qr_screen.dart` to use consistent package imports and resolve any potential conflicts or missing dependencies.

## Proposed Changes

### UI Screen

#### [membership_qr_screen.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/profile_screen/membership_qr_screen.dart)

- Convert all internal relative imports to package-based imports using `package:shopping_app/`.
- Organize imports according to Flutter/Dart best practices (dart imports, then package imports, then local project imports).
- Ensure all types used (like `OrderModel` and `MemberLevel`) are properly resolved.

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/model/order_model.dart';
import 'package:shopping_app/src/network/datastor/membership_service.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import 'qr_scanner_screen.dart';
```

## Verification Plan

### Automated Tests
- I will run `analyze_file` on `membership_qr_screen.dart` to ensure there are no static analysis errors after the change.

### Manual Verification
- Verify that the file compiles and the imports are correctly resolved by checking for any red squiggles or errors in the IDE context (simulated via `analyze_file`).
