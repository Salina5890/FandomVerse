import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'fv_icon.dart';

/// Fast, theme-aware image widget used throughout Fandom Verse.
///
/// Remote Unsplash images are requested at the size they are actually shown,
/// using WebP where supported. This prevents the app from downloading large
/// originals for small cards and makes scrolling considerably smoother.
class FVImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final bool isCircular;

  const FVImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = AppRadius.image,
    this.isCircular = false,
  });

  static String optimizedUrl(String url, {int? width}) {
    if (url.isEmpty) return url;
    try {
      final uri = Uri.parse(url);
      final host = uri.host;
      final targetWidth = (width ?? 720).clamp(240, 1200);

      if (host == 'images.unsplash.com') {
        final params = Map<String, String>.from(uri.queryParameters);
        params['auto'] = 'format';
        params['fit'] = 'crop';
        params['w'] = '$targetWidth';
        params['q'] = '72';
        return uri.replace(queryParameters: params).toString();
      }

      // Wikimedia URLs in the seed data already point at a resized thumbnail.
      // Leave them untouched so the browser can use the small, fast version.
      return url;
    } catch (_) {
      return url;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final viewportWidth = MediaQuery.sizeOf(context).width;
    // `width`/`height` are the *layout* size passed by callers and are
    // sometimes `double.infinity` (e.g. "fill the available width" inside a
    // bounded parent). That's valid for layout, but it must never reach the
    // cache-size math below: calling `.round()` on an infinite double throws
    // "Unsupported operation: Infinity" and previously surfaced as a broken
    // red error box wherever an image was rendered this way. Only use the
    // caller-provided size for cache sizing when it's finite; otherwise fall
    // back to the viewport width (and the standard aspect ratio for height).
    final hasFiniteWidth = width != null && width!.isFinite;
    final hasFiniteHeight = height != null && height!.isFinite;
    final logicalWidth = hasFiniteWidth ? width! : viewportWidth;
    final logicalHeight = hasFiniteHeight ? height! : logicalWidth * .68;
    final cacheWidth = (logicalWidth * dpr).round().clamp(160, 1800);
    final cacheHeight = (logicalHeight * dpr).round().clamp(120, 1800);
    final url = optimizedUrl(imageUrl, width: (logicalWidth * 1.2).round());

    final Widget image = imageUrl.startsWith('data:image/')
        ? Image.memory(
            base64Decode(imageUrl.substring(imageUrl.indexOf(',') + 1)),
            width: width,
            height: height,
            fit: fit,
            filterQuality: FilterQuality.low,
            errorBuilder: (_, __, ___) => _error(width, height),
          )
        : url.isEmpty
            ? _error(width, height)
            : CachedNetworkImage(
                imageUrl: url,
                width: width,
                height: height,
                fit: fit,
                memCacheWidth: cacheWidth,
                memCacheHeight: cacheHeight,
                filterQuality: FilterQuality.low,
                useOldImageOnUrlChange: true,
                fadeInDuration: const Duration(milliseconds: 120),
                fadeOutDuration: const Duration(milliseconds: 60),
                placeholder: (context, url) => _placeholder(width, height),
                errorWidget: (context, url, error) => _error(width, height),
              );

    return ClipRRect(
      borderRadius: isCircular
          ? BorderRadius.circular(hasFiniteWidth ? width! / 2 : 1000)
          : BorderRadius.circular(borderRadius),
      child: image,
    );
  }

  Widget _placeholder(double? width, double? height) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.cardElevated, AppColors.card],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Opacity(
            opacity: .35,
            child: FVIcon(PhosphorIconsRegular.image, size: 24, color: AppColors.primaryLight),
          ),
        ),
      );

  Widget _error(double? width, double? height) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.cardElevated, AppColors.surface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FVIcon(PhosphorIconsRegular.imageBroken, size: 25, color: AppColors.textTertiary),
        ),
      );
}
