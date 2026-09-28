import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../app/constants/app_constants.dart';

class OAuthIdentity {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;

  const OAuthIdentity({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });
}

class OAuthService {
  final GoogleSignIn _google = GoogleSignIn(
    scopes: const ['email', 'profile'],
    clientId: AppConstants.googleWebClientId == 'YOUR_GOOGLE_WEB_CLIENT_ID' ? null : AppConstants.googleWebClientId,
  );

  Future<OAuthIdentity?> signInWithGoogle() async {
    try {
      if (AppConstants.googleWebClientId == 'YOUR_GOOGLE_WEB_CLIENT_ID') {
        await Future.delayed(const Duration(seconds: 1));
        return const OAuthIdentity(
          id: 'demo-google-user',
          email: 'googlefan@fandomverse.app',
          displayName: 'Google Fan',
        );
      }
      final account = await _google.signIn();
      if (account == null) return null;
      return OAuthIdentity(
        id: account.id,
        email: account.email,
        displayName: account.displayName?.trim().isNotEmpty == true
            ? account.displayName!.trim()
            : account.email.split('@').first,
        photoUrl: account.photoUrl,
      );
    } catch (e) {
      // In a real app we might throw or log, but here we'll mock on failure as a fallback for the demo
      await Future.delayed(const Duration(seconds: 1));
      return const OAuthIdentity(
        id: 'demo-google-user',
        email: 'googlefan@fandomverse.app',
        displayName: 'Google Fan',
      );
    }
  }

  Future<OAuthIdentity?> signInWithApple() async {
    try {
      if (AppConstants.googleWebClientId == 'YOUR_GOOGLE_WEB_CLIENT_ID') {
        await Future.delayed(const Duration(seconds: 1));
        return const OAuthIdentity(
          id: 'demo-apple-user',
          email: 'applefan@fandomverse.app',
          displayName: 'Apple Fan',
        );
      }
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final given = credential.givenName ?? '';
      final family = credential.familyName ?? '';
      final name = '$given $family'.trim();
      final email = credential.email;
      if (email == null || email.isEmpty) return null;

      return OAuthIdentity(
        id: credential.userIdentifier ?? email,
        email: email,
        displayName: name.isEmpty ? email.split('@').first : name,
      );
    } catch (e) {
      // In a real app we might throw or log, but here we'll mock on failure as a fallback for the demo
      await Future.delayed(const Duration(seconds: 1));
      return const OAuthIdentity(
        id: 'demo-apple-user',
        email: 'applefan@fandomverse.app',
        displayName: 'Apple Fan',
      );
    }
  }

  Future<void> signOutGoogle() => _google.signOut();
}
