# Performance & Build-Stability Pass — Summary

No UI/design changes were made. Everything below is internal: state
management correctness, data caching, lazy loading, and dependency cleanup.

## 1. Controllers were being recreated on every rebuild (main cause of "heavy/slow")
Nearly every screen called `Get.put(XController())` directly inside `build()`,
with no `Binding` registered for the route. In GetX, `Get.put()`
unconditionally constructs a new controller and overwrites the old one — so
*any* rebuild (theme toggle, parent `Obx`, re-navigation, etc.) silently threw
away scroll position / filters / loading state and re-ran `onInit()` — which
reloads that screen's full data set — from scratch.

Fixed in 28 view files with a guard:
```dart
final controller = Get.isRegistered<X>() ? Get.find<X>() : Get.put(X());
```
The three routes that take constructor args (`FandomDetailController`,
`EventDetailController`, `ContentDetailController`) use the same guard keyed
by `tag:` so navigating to a *different* item still creates a fresh instance,
while revisiting the same one reuses it.

## 2. All 5 bottom-nav tabs were built and initialized at startup
`FanMainView`'s `IndexedStack` listed all five tab widgets in `children`
eagerly, so Home/Explore/Events/Store/Profile all initialized and loaded
their data immediately on launch, regardless of which tab was visible.

Fixed: `FanMainController` now tracks `visitedTabs`; `FanMainView` only
places a tab's real (const, identity-preserving) widget in the stack the
first time it's opened — unvisited tabs render as a free `SizedBox.shrink()`
placeholder. Visited tabs stay resident afterwards (state preserved), same
as before.

## 3. The mock dataset was rebuilt from scratch on every access
`SeedDataService` exposed its data (fandoms, content, events, products,
badges, FAQs, glossary, characters) as `static get` computed properties, so
each of the 63 call sites across the app reconstructed the full object
graphs (with fresh `DateTime.now()` calls) every time. Converted all 9 into
cached `static final` fields computed once; the original getter names are
unchanged, so no call sites needed to change.

## 4. Startup services parallelized
`AuthService` and `NotificationService` only depend on `LocalStorageService`
(not on each other), so `main.dart` now initializes them with `Future.wait`
instead of one after the other.

## 5. Dependency cleanup (`pubspec.yaml`)
Removed packages with zero references anywhere in `lib/` (verified by
grepping for `package:<name>` imports and their public API symbols):
`connectivity_plus`, `dio`, `flutter_secure_storage`, `permission_handler`,
`shimmer`, `lottie`, `table_calendar`, `fl_chart`, `path_provider`,
`cupertino_icons`, and the direct `hive` entry (still pulled in transitively
by `hive_flutter`, which is what's actually used). Also removed
`hive_generator` and `build_runner` from `dev_dependencies` — there are no
`@HiveType`/`@HiveField` annotations or generated `.g.dart` files anywhere;
Hive is used purely with dynamic boxes, so these codegen packages (and the
large `analyzer`/`build_*` chain they pull in) were dead weight on `pub get`
and IDE analysis.

`pubspec.lock` was removed so it regenerates cleanly against the trimmed
`pubspec.yaml` — this is expected; just run `flutter pub get`.

## 6. Image loading — already solid, no change needed
`FVImage` (the shared image widget) already wraps `CachedNetworkImage` with
correct `memCacheWidth`/`memCacheHeight` sizing and downsizes Unsplash URLs
to the rendered size. No fix needed here.

## Known trade-off left as-is
`ThemeController.setDark()` walks the entire Element tree calling
`markNeedsBuild()` on every element to force a full repaint on theme toggle,
because color values are read from static `AppColors` getters rather than an
`InheritedWidget`. This only fires when the user manually toggles the theme
(not a startup or scroll cost), and properly fixing it would mean changing
how every screen reads colors — a bigger architectural change than
"performance pass without redesign" covers. Flagging it here for a future,
dedicated pass if you want it addressed.

## What I could not verify directly
This container has no Flutter/Dart SDK and no network access, so I could not
run `flutter pub get`, `flutter analyze`, or a build. `pubspec.lock` (now
removed, see above) showed a fully resolved, healthy dependency graph before
these edits, and every edited file was checked for brace/paren/bracket
balance. Please run locally to confirm:

```bash
flutter pub get
flutter analyze
flutter build apk --debug   # or ios/web as applicable
```
