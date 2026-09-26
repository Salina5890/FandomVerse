import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/services/notification_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Get.find<NotificationService>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(onPressed: service.markAllRead, child: Text('Mark All Read', style: TextStyle(color: AppColors.accent))),
        ],
      ),
      body: Obx(() {
        final items = service.notifications;
        if (items.isEmpty) return const Center(child: Text("You're all caught up."));
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (_, index) => _item(service, items[index]),
        );
      }),
    );
  }

  Widget _item(NotificationService service, NotificationModel n) {
    return InkWell(
      onTap: () async {
        await service.markRead(n.id);
        if (n.route != null) Get.toNamed(n.route!, arguments: n.arguments);
      },
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: n.isRead ? AppColors.card : AppColors.cardElevated,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: n.isRead ? AppColors.borderSubtle : AppColors.primary.withValues(alpha: .35)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)), child: FVIcon(_icon(n.iconKey), color: AppColors.primaryLight, size: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(n.title, style: AppTypography.headingSmall)), if (!n.isRead) Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle))]),
            const SizedBox(height: 4),
            Text(n.message, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Text(_timeAgo(n.timestamp), style: AppTypography.caption.copyWith(color: AppColors.textTertiary)),
          ])),
        ]),
      ),
    );
  }

  IconData _icon(String? key) {
    switch (key) {
      case 'tag': return PhosphorIconsRegular.tag;
      case 'calendar': return PhosphorIconsRegular.calendar;
      case 'shoppingCart': return PhosphorIconsRegular.shoppingCart;
      case 'bookmark': return PhosphorIconsRegular.bookmarkSimple;
      case 'star': return PhosphorIconsRegular.star;
      default: return PhosphorIconsRegular.bell;
    }
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${diff.inDays ~/ 7}w ago';
  }
}
