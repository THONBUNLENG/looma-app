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
        case 'invalid-verification-code':
          return 'The verification code is invalid. Please try again.'.tr;
        case 'invalid-verification-id':
          return 'Verification ID is invalid. Please request a new code.'.tr;
        case 'session-expired':
          return 'The session has expired. Please try again.'.tr;
        case 'quota-exceeded':
          return 'SMS quota exceeded. Please try again later.'.tr;
        default:
          return 'An error occurred. Please try again.'.tr;
      }
    } else if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'You do not have permission to perform this action.'.tr;
        case 'unavailable':
          return 'The service is currently unavailable. Please try again later.'.tr;
        case 'not-found':
          return 'The requested resource was not found.'.tr;
        case 'already-exists':
          return 'The resource already exists.'.tr;
        default:
          return 'An error occurred. Please try again.'.tr;
      }
    }
    return 'An error occurred. Please try again.'.tr;
  }
}
