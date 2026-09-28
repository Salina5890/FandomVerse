import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../data/models/cart_models.dart';
import '../controllers/purchase_history_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PurchaseHistoryView extends GetView<PurchaseHistoryController> {
  const PurchaseHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Purchase History', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FVIcon(PhosphorIconsRegular.clockCounterClockwise, size: 80, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                const SizedBox(height: AppSpacing.md),
                Text('No orders yet', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: AppSpacing.lg),
                FVButton(
                  text: 'Start Shopping',
                  onPressed: () => Get.offAllNamed(AppRoutes.fanMain),
                  variant: FVButtonVariant.primary,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          itemCount: controller.orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            final dateFormat = DateFormat('MMM dd, yyyy');
            
            Color statusColor;
            switch (order.status) {
              case 'delivered':
                statusColor = AppColors.success;
                break;
              case 'processing':
                statusColor = AppColors.warning;
                break;
              case 'cancelled':
                statusColor = AppColors.error;
                break;
              default:
                statusColor = AppColors.textSecondary;
            }

            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #${order.id.substring(0, 8).toUpperCase()}',
                        style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          order.status.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(color: statusColor),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: AppColors.borderSubtle, height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      Text(dateFormat.format(order.createdAt), style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Items', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      Text('${order.items.length} items', style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      Text('\$${order.total.toStringAsFixed(2)}', style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
