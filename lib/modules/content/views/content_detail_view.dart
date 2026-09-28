import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/content_detail_controller.dart';
import '../../../data/models/content_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ContentDetailView extends StatelessWidget {
  const ContentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final contentId = Get.parameters['id'] ?? '';
    final controller = Get.isRegistered<ContentDetailController>(tag: contentId)
        ? Get.find<ContentDetailController>(tag: contentId)
        : Get.put(ContentDetailController(contentId), tag: contentId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final content = controller.content.value;
        if (content == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FVIcon(PhosphorIconsRegular.warningCircle, size: 64, color: AppColors.textTertiary),
                const SizedBox(height: 16),
                Text('Content not found', style: AppTypography.headingMedium),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // ── Hero Image App Bar ────────────────────────────
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: AppColors.surface,
              leading: _circleButton(
                icon: PhosphorIconsRegular.arrowLeft,
                onPressed: () => Get.back(),
              ),
              actions: [
                Obx(() => _circleButton(
                  icon: controller.isBookmarked.value
                      ? PhosphorIconsFill.bookmarkSimple
                      : PhosphorIconsRegular.bookmarkSimple,
                  onPressed: controller.toggleBookmark,
                )),
                Obx(() => _circleButton(
                  icon: controller.isOfflineSaved.value
                      ? PhosphorIconsFill.downloadSimple
                      : PhosphorIconsRegular.downloadSimple,
                  onPressed: controller.toggleOffline,
                )),
                const SizedBox(width: 8),
                _circleButton(
                  icon: PhosphorIconsRegular.shareNetwork,
                  onPressed: () => Share.share('${content.title} — ${content.description}'),
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (content.imageUrl != null)
                      FVImage(
                        imageUrl: content.imageUrl!,
                        borderRadius: 0,
                        fit: BoxFit.cover,
                      ),
                    // Gradient overlay
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color(0xCC0A0A0F),
                            AppColors.background,
                          ],
                          stops: [0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Content Body ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Content type badge & fandom
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(AppRadius.chip),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(content.contentType.icon,
                                  style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 4),
                              Text(
                                content.contentType.label,
                                style: AppTypography.labelSmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (content.fandomName != null)
                          Text(
                            content.fandomName!,
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.cyan,
                            ),
                          ),
                        const Spacer(),
                        Text(
                          DateFormat('MMM dd, yyyy').format(content.createdAt),
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Title
                    Text(
                      content.title,
                      style: AppTypography.headingXL.copyWith(height: 1.3),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Author & read time
                    Row(
                      children: [
                        FVIcon(PhosphorIconsRegular.user,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          content.author,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        FVIcon(PhosphorIconsRegular.clock,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${content.readTimeMinutes} min read',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        FVIcon(PhosphorIconsRegular.eye,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          _formatCount(content.viewCount),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Divider
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.5),
                            AppColors.accent.withValues(alpha: 0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Description
                    Text(
                      content.description,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    if ((content.contentType == ContentType.video || content.contentType == ContentType.podcast) && content.mediaUrl != null) ...[
                      _mediaAction(content),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                    if (content.contentType == ContentType.gallery && content.galleryUrls.isNotEmpty) ...[
                      _gallery(content.galleryUrls),
                      const SizedBox(height: AppSpacing.xl),
                    ],

                    // Body
                    Text(
                      content.body,
                      style: AppTypography.bodyMedium.copyWith(height: 1.8),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Tags
                    if (content.tags.isNotEmpty) ...[
                      Text('Tags', style: AppTypography.labelLarge),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: content.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.chip),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              '#$tag',
                              style: AppTypography.chipLabel.copyWith(
                                color: AppColors.primaryLight,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],

                    // Offline status indicator
                    Obx(() => Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                      ),
                      child: Row(children: [
                        FVIcon(PhosphorIconsRegular.downloadSimple, color: AppColors.cyan, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          controller.isOfflineSaved.value
                              ? 'Available Offline'
                              : (content.isOfflineAvailable ? 'Offline-ready — tap download to save' : 'Not Available Offline'),
                          style: AppTypography.labelMedium.copyWith(color: AppColors.cyan),
                        ),
                      ]),
                    )),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _mediaAction(ContentModel content) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.border)),
    child: Row(children: [
      FVIcon(content.contentType == ContentType.video ? PhosphorIconsRegular.playCircle : PhosphorIconsRegular.headphones, color: AppColors.primaryLight, size: 30),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(content.contentType == ContentType.video ? 'Video' : 'Podcast', style: AppTypography.labelLarge),
        if (content.durationSeconds != null) Text(_duration(content.durationSeconds!), style: AppTypography.caption),
      ])),
      ElevatedButton(onPressed: () => _launchMedia(content.mediaUrl!), child: const Text('Play')),
    ]),
  );

  Widget _gallery(List<String> urls) => SizedBox(
    height: 120,
    child: ListView.separated(
      scrollDirection: Axis.horizontal, itemCount: urls.length, separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, i) => GestureDetector(
        onTap: () => Get.dialog(Dialog(child: _GalleryViewer(urls: urls, initialIndex: i))),
        child: FVImage(imageUrl: urls[i], width: 160, height: 120, borderRadius: AppRadius.sm),
      ),
    ),
  );

  Future<void> _launchMedia(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Media', 'This media source is unavailable.');
    }
  }

  String _duration(int seconds) => '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.7),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: FVIcon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}


class _GalleryViewer extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;
  const _GalleryViewer({required this.urls, required this.initialIndex});
  @override State<_GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<_GalleryViewer> {
  late final PageController _controller;
  @override void initState() { super.initState(); _controller = PageController(initialPage: widget.initialIndex); }
  @override void dispose() { _controller.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => SizedBox(
    width: double.infinity, height: MediaQuery.of(context).size.height * .75,
    child: PageView.builder(
      controller: _controller, itemCount: widget.urls.length,
      itemBuilder: (_, i) => InteractiveViewer(child: FVImage(imageUrl: widget.urls[i], fit: BoxFit.contain, borderRadius: 0)),
    ),
  );
}
