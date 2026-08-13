import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthLoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save User Data to Firestore
  Future<void> saveUserData({
    required String uid,
    required String name,
    String? email,
    String? phone,
    String? photoUrl,
    String? password,
    String? address,
  }) async {
    try {
      await _firestore.collection('user').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'photoUrl': photoUrl,
        'address': address,
        'password': password,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error saving user data to Firestore: $e");
    }
  }

  // Upload Profile Picture
  Future<String?> uploadProfilePicture(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_pictures').child('$userId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return null;
    }
  }

  // 1. Google Login (Adapted for google_sign_in v7.2.0+)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        debugPrint("Google Sign-In: User canceled.");
        return null;
      }
      rethrow;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      rethrow;
    }
  }

  // 1.1 Apple Login
  Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthCredential credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint("Apple Sign-In Error: $e");
      if (e.toString().contains(
        'com.apple.AuthenticationServices.AuthorizationError',
      )) {
        debugPrint(
          "CRITICAL: Apple Sign-In is likely not configured in Xcode. Please add the 'Sign In with Apple' capability.",
        );
      } else if (e.toString().contains('Firebase/Core')) {
        debugPrint(
          "CRITICAL: GoogleService-Info.plist might be missing from your ios/Runner directory.",
        );
      }
      return null;
    }
  }

  // 1.2 Facebook Login
  Future<Map<String, dynamic>> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );
        final userCredential = await _auth.signInWithCredential(credential);
        return {'userCredential': userCredential, 'error': null};
      } else if (result.status == LoginStatus.cancelled) {
        return {'userCredential': null, 'error': 'Canceled by user'};
      }
      return {'userCredential': null, 'error': result.message ?? 'Unknown error'};
    } catch (e) {
      debugPrint("Facebook Sign-In Error: $e");
      return {'userCredential': null, 'error': e.toString()};
    }
  }

  // 2. Email/Password Registration
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Registration  Error [${e.code}]: ${e.message}");
      if (e.code == 'api-key-not-valid' ||
          e.message?.contains('API key not valid') == true) {
        debugPrint(
          "CRITICAL ERROR: Firebase API Key is not valid. Please regenerate your google-services.json file and ensure it is not restricted in Google Cloud Console.",
        );
      }
      rethrow;
    } catch (e) {
      debugPrint("Registration General Error: $e");
      rethrow;
    }
  }

  // 3. Email/Password Login
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint("Login Error: $e");
      rethrow;
    }
  }

  // 3.1 Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint("Password Reset Error [${e.code}]: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("Password Reset General Error: $e");
      rethrow;
    }
  }

  // 3.2 Update User Password (Authenticated)
  Future<void> updateUserPassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      } else {
        throw "User not authenticated";
      }
    } catch (e) {
      debugPrint("Update Password Error: $e");
      rethrow;
    }
  }

  // 3.3 Re-authenticate with Password
  Future<void> reauthenticate(String password) async {
    try {
      final user = _auth.currentUser;
      if (user != null && user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      } else {
        throw "User not logged in with email";
      }
    } catch (e) {
      debugPrint("Re-authentication Error: $e");
      rethrow;
    }
  }

  // 3.4 Check if user is using email/password
  bool isEmailUser() {
    final user = _auth.currentUser;
    if (user == null) return false;
    for (final info in user.providerData) {
      if (info.providerId == 'password') return true;
    }
    return false;
  }

  // 4. verifyPhoneNumber
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException e) onVerificationFailed,
    Function(AuthCredential credential)? onVerificationCompleted,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (onVerificationCompleted != null) {
          onVerificationCompleted(credential);
        } else {
          await _auth.signInWithCredential(credential);
        }
      },
      verificationFailed: onVerificationFailed,
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // 5. signInWithOTP
  Future<UserCredential?> signInWithOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint("OTP Verification Error: $e");
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      debugPrint("Social Sign-Out Error: $e");
    }
    await _auth.signOut();
  }

  // Delete Account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
      await signOut();
    } catch (e) {
      debugPrint("Error deleting account: $e");
      rethrow;
    }
  }
}
