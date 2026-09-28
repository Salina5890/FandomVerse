# fandom_verse

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Rose Quartz theme (light + dark)
- Colours live in `lib/app/theme/app_colors.dart` (sampled from the mockup). They are runtime getters, so toggling in **Settings → Appearance** re-skins the whole app (`lib/core/theme/theme_controller.dart`, saved in Hive).
- Icons: `phosphor_flutter` (pub.dev). Animations: `flutter_animate` + helpers in `lib/core/widgets/fv_animations.dart`.
- Run `flutter pub get` after pulling (new dependency: phosphor_flutter).
