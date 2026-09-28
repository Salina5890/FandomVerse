# Fandom Verse — Missing Feature Setup

This build extends the existing project without replacing its GetX/Hive architecture.

## Required external configuration

### Google Sign-In
- Android: configure the Android OAuth client in Google Cloud and the generated signing certificate/package configuration.
- Web/Chrome: replace `YOUR_GOOGLE_WEB_CLIENT_ID` in `web/index.html`, or pass `--dart-define=GOOGLE_WEB_CLIENT_ID=...`.
- Authorized JavaScript origins must include the deployed web origin.

### Apple Sign-In
- Configure Sign in with Apple identifiers, capabilities, Service ID/redirect settings where required by the target platform.
- The Flutter integration is real; credentials and Apple Developer configuration are external to source control.

### Google Maps
- Replace `YOUR_GOOGLE_MAPS_API_KEY` in the Android manifest and web Maps script, or pass `--dart-define=GOOGLE_MAPS_API_KEY=...` for the Dart-side guard.
- Restrict browser/mobile keys appropriately in Google Cloud.
- Set `AppConstants.officeLatitude`, `officeLongitude`, and `officeAddress` to the actual project owner details before enabling the Contact/Office map.

## Local-only functionality

The following are intentionally local because the supplied project has no backend/push service:
- notifications
- contact inquiries
- wishlist price-drop detection
- offline text caching
- order confirmation notification

No UI claims that an email was sent or a remote submission was completed.

## Media

`ContentModel` now supports `mediaUrl`, `durationSeconds`, and `galleryUrls`. Video/podcast sources are opened through the platform URL launcher when a real source is present. Gallery content uses a full-screen swipe/zoom viewer when gallery URLs are supplied.

## Verification environment

The supplied execution environment did not contain the Flutter/Dart CLI, so `flutter pub get`, `flutter analyze`, `flutter test`, and `flutter run -d chrome` could not be executed here. The project should be verified with those commands on a Flutter development machine after adding the required credentials.
