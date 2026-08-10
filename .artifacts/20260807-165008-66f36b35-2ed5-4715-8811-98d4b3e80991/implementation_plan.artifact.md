# Implementation Plan - Add Camera to QR Scanner Screen

This plan outlines the steps to add real QR scanning functionality to the `QRScannerScreen` using the `mobile_scanner` package.

## Proposed Changes

### Dependencies & Config

#### [pubspec.yaml](file:///C:/Users/ASUS/Documents/looma-app/pubspec.yaml)
- Add `mobile_scanner: ^5.1.1` to the dependencies.

#### [ios/Runner/Info.plist](file:///C:/Users/ASUS/Documents/looma-app/ios/Runner/Info.plist)
- Add `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` for camera and gallery access.

### Features

#### [qr_scanner_screen.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/home_screen/profile_screen/qr_scanner_screen.dart)
- Import `package:mobile_scanner/mobile_scanner.dart` and `package:image_picker/image_picker.dart`.
- Initialize `MobileScannerController` in `initState` and dispose it in `dispose`.
- Replace the camera placeholder with the `MobileScanner` widget.
- Update flash toggle button to use `controller.toggleTorch()`.
- Update camera switch button to use `controller.switchCamera()`.
- Implement gallery picking logic using `ImagePicker` and `controller.analyzeImage()`.
- Handle barcode detection by popping the result back to the previous screen.

## Verification Plan

### Automated Tests
- I will run `analyze_file` on the modified `qr_scanner_screen.dart` to check for any syntax or type errors.

### Manual Verification
- Since I cannot run the app on a physical device, I will verify the code structure and logic through static analysis and ensure all controller calls are correct according to the `mobile_scanner` documentation.
- I will verify that the permissions are added correctly to `Info.plist`.
