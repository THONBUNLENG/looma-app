# Fix Google Sign-In Error

The "Google Sign-In canceled or failed" error is often a generic message shown when the sign-in process returns null. This can be caused by configuration issues (like missing SHA-1 fingerprints in Firebase) or code implementation details that are not robust enough for the new `google_sign_in` 7.x API.

## Proposed Changes

### Auth Service Component

Modify `AuthLoginService` to improve error handling and simplify the Google Sign-In flow. The current implementation uses `authorizeScopes([])` which is often unnecessary for basic Firebase authentication and might be causing additional prompts or failures.

#### [auth_login_service.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/network/datastor/auth_login_service.dart)

- Remove the `try-catch` block inside `signInWithGoogle` or change it to `rethrow` so the calling Bloc can handle and display the specific error message.
- Remove the unnecessary `authorizeScopes([])` call. For Firebase authentication, the `idToken` from the authentication step is sufficient.
- Ensure the method handles the user canceling the sign-in gracefully.

```diff
   // 1. Google Login (Adapted for google_sign_in v7.2.0+)
   Future<UserCredential?> signInWithGoogle() async {
     try {
       final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

       final GoogleSignInAuthentication googleAuth = googleUser.authentication;

-      final authorization = await googleUser.authorizationClient
-          .authorizeScopes([]);
-
       final AuthCredential credential = GoogleAuthProvider.credential(
-        accessToken: authorization.accessToken,
         idToken: googleAuth.idToken,
       );

       return await _auth.signInWithCredential(credential);
+    } on GoogleSignInException catch (e) {
+      if (e.code == GoogleSignInExceptionCode.canceled) {
+        debugPrint("Google Sign-In: User canceled.");
+        return null;
+      }
+      rethrow;
     } catch (e) {
       debugPrint("Google Sign-In Error: $e");
-      return null;
+      rethrow;
     }
   }
```

### Login Bloc Component

Update `LoginBloc` to handle the case where `signInWithGoogle` returns `null` (canceled) vs throws an error (failed).

#### [login_bloc.dart](file:///C:/Users/ASUS/Documents/looma-app/lib/src/screen/login_screen/bloc/login_bloc.dart)

- Update `_onGoogleSignInRequested` to distinguish between a user cancellation and a real failure.

```diff
   Future<void> _onGoogleSignInRequested(
     GoogleSignInRequested event,
     Emitter<LoginState> emit,
   ) async {
     emit(LoginLoading());
     try {
       final UserCredential? userCredential = await _authLoginService.signInWithGoogle();
       if (userCredential != null && userCredential.user != null) {
         final User user = userCredential.user!;
         await AuthService.saveLoginData(
           username: user.displayName ?? "User",
           phone: user.phoneNumber ?? "",
           picture: user.photoURL,
           token: await user.getIdToken(),
         );
         emit(LoginSuccess(user.displayName ?? "User"));
-      } else {
-        emit(LoginFailure("Google Sign-In canceled or failed."));
-      }
+      } else {
+        // User canceled, just emit initial or previous state to clear loading
+        emit(LoginInitial());
+      }
     } catch (e) {
       emit(LoginFailure(FirebaseErrorHandler.getErrorMessage(e)));
     }
   }
```

## Verification Plan

### Manual Verification
1. **Improve Logging**: The changes above will ensure that the ACTUAL error is printed to the console and shown in the UI.
2. **SHA-1 Verification**:
    - Run `./gradlew signingReport` in the `android` folder to get the SHA-1 of the debug key.
    - Verify that this SHA-1 is added to the Firebase Console project settings for the Android app.
3. **Run the app**: Attempt to sign in again. If it still fails, the UI will now show a more specific error message (e.g., "developer_error" or "ApiException 10") which will confirm the SHA-1 issue.
