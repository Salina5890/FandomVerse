import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_icon.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../data/models/content_model.dart';

class GalleryFullScreenView extends StatefulWidget {
  final ContentModel content;
  final int initialIndex;

  const GalleryFullScreenView({
    super.key,
    required this.content,
    this.initialIndex = 0,
  });

  @override
  State<GalleryFullScreenView> createState() => _GalleryFullScreenViewState();
}

class _GalleryFullScreenViewState extends State<GalleryFullScreenView> {
  late PageController _pageController;
  late int _currentIndex;
  late List<String> _images;
  final RxBool _isBookmarked = false.obs;
  final RxBool _isOfflineSaved = false.obs;
  bool _showControls = true;

  final TransformationController _transformController = TransformationController();

  @override
  void initState() {
    super.initState();
    _images = widget.content.galleryUrls.isNotEmpty
        ? widget.content.galleryUrls
        : (widget.content.imageUrl != null ? [widget.content.imageUrl!] : []);
    _currentIndex = widget.initialIndex.clamp(0, _images.isEmpty ? 0 : _images.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
    _isOfflineSaved.value = widget.content.isOfflineAvailable;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  void _handleOfflineSave() {
    _isOfflineSaved.toggle();
    Get.rawSnackbar(
      title: _isOfflineSaved.value ? 'Saved Offline' : 'Removed from Offline',
      message: _isOfflineSaved.value
          ? 'Image downloaded and saved to your offline gallery cache.'
          : 'Image removed from offline cache.',
      icon: FVIcon(
        _isOfflineSaved.value ? PhosphorIconsFill.downloadSimple : PhosphorIconsRegular.downloadSimple,
        color: AppColors.primaryLight,
      ),
      backgroundColor: AppColors.card,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(AppSpacing.md),
      borderRadius: 14,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleBookmark() {
    _isBookmarked.toggle();
    Get.rawSnackbar(
      title: _isBookmarked.value ? 'Bookmarked' : 'Bookmark Removed',
      message: _isBookmarked.value
          ? 'Added "${widget.content.title}" to your saved collection.'
          : 'Removed from bookmarks.',
      icon: FVIcon(
        _isBookmarked.value ? PhosphorIconsFill.bookmarkSimple : PhosphorIconsRegular.bookmarkSimple,
        color: AppColors.accent,
      ),
      backgroundColor: AppColors.card,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(AppSpacing.md),
      borderRadius: 14,
      duration: const Duration(seconds: 2),
    );
  }

  void _showInfoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.content.fandomName ?? 'Fandom Art',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '4K Ultra HD',
                      style: AppTypography.caption.copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(widget.content.title, style: AppTypography.headingMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Created by ${widget.content.author}',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  widget.content.description,
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.content.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text('#$tag', style: AppTypography.caption),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_images.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: const Center(child: Text('No image available', style: TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // PageView for swipeable images
          GestureDetector(
            onTap: _toggleControls,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  transformationController: _transformController,
                  minScale: 0.8,
                  maxScale: 4.5,
                  child: Center(
                    child: Hero(
                      tag: index == 0 ? 'gallery_${widget.content.id}' : 'gallery_${widget.content.id}_$index',
                      child: FVImage(
                        imageUrl: _images[index],
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Top App Bar Controls
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            top: _showControls ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                bottom: 12,
                left: 12,
                right: 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  _circleActionButton(
                    icon: PhosphorIconsRegular.caretLeft,
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.content.title,
                          style: AppTypography.headingSmall.copyWith(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_images.length > 1)
                          Text(
                            '${_currentIndex + 1} of ${_images.length}',
                            style: AppTypography.caption.copyWith(color: Colors.white70),
                          ),
                      ],
                    ),
                  ),
                  _circleActionButton(
                    icon: PhosphorIconsRegular.shareNetwork,
                    onPressed: () => Share.share(
                      'Check out "${widget.content.title}" in FandomVerse!\n${_images[_currentIndex]}',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar Controls
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            bottom: _showControls ? 0 : -120,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
                left: AppSpacing.pagePadding,
                right: AppSpacing.pagePadding,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.90),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() => _glassButton(
                    icon: _isOfflineSaved.value
                        ? PhosphorIconsFill.downloadSimple
                        : PhosphorIconsRegular.downloadSimple,
                    label: _isOfflineSaved.value ? 'Saved' : 'Save Offline',
                    isActive: _isOfflineSaved.value,
                    activeColor: AppColors.primaryLight,
                    onPressed: _handleOfflineSave,
                  )),
                  Obx(() => _glassButton(
                    icon: _isBookmarked.value
                        ? PhosphorIconsFill.bookmarkSimple
                        : PhosphorIconsRegular.bookmarkSimple,
                    label: _isBookmarked.value ? 'Bookmarked' : 'Bookmark',
                    isActive: _isBookmarked.value,
                    activeColor: AppColors.accent,
                    onPressed: _handleBookmark,
                  )),
                  _glassButton(
                    icon: PhosphorIconsRegular.info,
                    label: 'Details',
                    isActive: false,
                    onPressed: _showInfoSheet,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleActionButton({required IconData icon, required VoidCallback onPressed}) {
    return Material(
      color: Colors.white.withValues(alpha: 0.16),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FVIcon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _glassButton({
    required IconData icon,
    required String label,
    required bool isActive,
    Color? activeColor,
    required VoidCallback onPressed,
  }) {
    final color = isActive ? (activeColor ?? AppColors.primaryLight) : Colors.white;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? (activeColor ?? AppColors.primary).withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? (activeColor ?? AppColors.primary) : Colors.white.withValues(alpha: 0.20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FVIcon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.buttonSmall.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
