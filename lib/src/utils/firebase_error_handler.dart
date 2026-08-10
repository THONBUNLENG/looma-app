import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/string_extension.dart';

class FirebaseErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'The email address is not valid. Please check and try again.'.tr;
        case 'user-disabled':
          return 'This user account has been disabled.'.tr;
        case 'user-not-found':
          return 'No user found with this email.'.tr;
        case 'wrong-password':
          return 'Incorrect password. Please try again.'.tr;
        case 'email-already-in-use':
          return 'This email is already registered.'.tr;
        case 'operation-not-allowed':
          return 'Login with email is currently disabled.'.tr;
        case 'weak-password':
          return 'The password is too weak.'.tr;
        case 'invalid-credential':
          return 'Invalid login details.'.tr;
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.'.tr;
        case 'account-exists-with-different-credential':
          return 'An account already exists with the same email address but different sign-in credentials.'.tr;
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.'.tr;
        default:
          return error.message ?? 'An error occurred. Please try again.'.tr;
      }
    }
    return error.toString();
  }
}
