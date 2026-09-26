import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/bookmarks_controller.dart';
import '../../../data/models/cart_models.dart';
import '../../../data/models/content_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BookmarksView extends StatelessWidget {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<BookmarksController>() ? Get.find<BookmarksController>() : Get.put(BookmarksController());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Library'),
          backgroundColor: AppColors.surface,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Bookmarks'),
              Tab(text: 'Saved'),
              Tab(text: 'Offline'),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primaryLight,
            unselectedLabelColor: AppColors.textSecondary,
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return TabBarView(
            children: [
              _buildBookmarksList(
                controller.bookmarks,
                controller,
                'No Bookmarks Yet',
                'PhosphorIconsRegular.bookmarkSimple',
                (id) => controller.removeBookmark(id),
              ),
              _buildBookmarksList(
                controller.savedContent,
                controller,
                'No Saved Content',
                'PhosphorIconsRegular.downloadSimple',
                (id) => controller.removeSavedContent(id),
              ),
              _buildOfflineList(controller.offlineContent, controller),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBookmarksList(
    List<BookmarkModel> items,
    BookmarksController controller,
    String emptyMessage,
    String iconString,
    Function(String) onRemove,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FVIcon(PhosphorIconsRegular.bookmarkSimple, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(emptyMessage, style: AppTypography.headingMedium),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => controller.loadData(),
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final item = items[index];
          return Dismissible(
            key: Key(item.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: FVIcon(PhosphorIconsRegular.trash, color: AppColors.error),
            ),
            onDismissed: (_) => onRemove(item.id),
            child: GestureDetector(
              onTap: () => controller.openBookmark(item),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    if (item.contentImageUrl != null)
                      FVImage(
                        imageUrl: item.contentImageUrl!,
                        width: 70,
                        height: 70,
                        borderRadius: AppRadius.sm,
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppRadius.chip),
                            ),
                            child: Text(
                              item.contentType.toUpperCase(),
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primaryLight,
                                fontSize: 9,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.contentTitle,
                            style: AppTypography.headingSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: FVIcon(PhosphorIconsFill.bookmarkSimple, color: AppColors.accent),
                      onPressed: () => onRemove(item.id),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOfflineList(List<ContentModel> items, BookmarksController controller) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FVIcon(PhosphorIconsRegular.downloadSimple, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text('No Offline Content', style: AppTypography.headingMedium),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final content = items[index];
        return GestureDetector(
          onTap: () => controller.openContent(content.id),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                if (content.imageUrl != null)
                  FVImage(
                    imageUrl: content.imageUrl!,
                    width: 70,
                    height: 70,
                    borderRadius: AppRadius.sm,
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FVIcon(PhosphorIconsRegular.downloadSimple, color: AppColors.cyan, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'Available Offline',
                            style: AppTypography.caption.copyWith(color: AppColors.cyan),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        content.title,
                        style: AppTypography.headingSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
