import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'fv_icon.dart';

/// Fast, theme-aware image widget used throughout Fandom Verse.
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
    final trimmed = url.trim();
    if (trimmed.isEmpty) return trimmed;
    try {
      final uri = Uri.parse(trimmed);
      final host = uri.host;
      final targetWidth = (width ?? 720).clamp(240, 1200);

      if (host == 'images.unsplash.com') {
        final params = Map<String, String>.from(uri.queryParameters);
        params['auto'] = 'format';
        params['fit'] = 'crop';
        params['w'] = '$targetWidth';
        params['q'] = '80';
        return uri.replace(queryParameters: params).toString();
      }

      return trimmed;
    } catch (_) {
      return trimmed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cleanUrl = imageUrl.trim();
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final viewportWidth = MediaQuery.sizeOf(context).width;

    final hasFiniteWidth = width != null && width!.isFinite;
    final hasFiniteHeight = height != null && height!.isFinite;
    final logicalWidth = hasFiniteWidth ? width! : viewportWidth;
    final logicalHeight = hasFiniteHeight ? height! : logicalWidth * .68;

    final cacheWidth = (logicalWidth * dpr).round().clamp(160, 1800);
    final cacheHeight = (logicalHeight * dpr).round().clamp(120, 1800);
    final url = optimizedUrl(cleanUrl, width: (logicalWidth * 1.2).round());

    final Widget image = cleanUrl.startsWith('data:image/')
        ? Image.memory(
            base64Decode(cleanUrl.substring(cleanUrl.indexOf(',') + 1)),
            width: width,
            height: height,
            fit: fit,
            filterQuality: FilterQuality.medium,
            errorBuilder: (_, __, ___) => _fallback(width, height),
          )
        : url.isEmpty
            ? _fallback(width, height)
            : CachedNetworkImage(
                imageUrl: url,
                width: width,
                height: height,
                fit: fit,
                memCacheWidth: kIsWeb ? null : cacheWidth,
                memCacheHeight: kIsWeb ? null : cacheHeight,
                filterQuality: FilterQuality.medium,
                useOldImageOnUrlChange: true,
                fadeInDuration: const Duration(milliseconds: 150),
                fadeOutDuration: const Duration(milliseconds: 80),
                placeholder: (context, url) => _placeholder(width, height),
                errorWidget: (context, url, error) => _fallback(width, height),
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
            colors: [
              AppColors.cardElevated,
              AppColors.card,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Opacity(
            opacity: .4,
            child: FVIcon(
              PhosphorIconsRegular.image,
              size: 24,
              color: AppColors.primaryLight,
            ),
          ),
        ),
      );

  Widget _fallback(double? width, double? height) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.cardElevated,
              AppColors.surface,
              AppColors.background,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Opacity(
            opacity: .4,
            child: FVIcon(
              PhosphorIconsRegular.sparkle,
              size: 24,
              color: AppColors.primaryLight,
            ),
          ),
        ),
      );
}
