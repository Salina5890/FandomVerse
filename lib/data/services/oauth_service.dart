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
  }

  Future<OAuthIdentity?> signInWithApple() async {
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
  }

  Future<void> signOutGoogle() => _google.signOut();
}
