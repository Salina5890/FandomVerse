import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/events_controller.dart';
import '../../../data/models/event_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<EventsController>() ? Get.find<EventsController>() : Get.put(EventsController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Events'),
          actions: [
            IconButton(
              icon: const FVIcon(PhosphorIconsRegular.mapTrifold),
              onPressed: () => Get.toNamed(AppRoutes.nearbyEvents),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primaryLight,
            unselectedLabelColor: AppColors.textSecondary,
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          return TabBarView(
            children: [
              _buildEventList(controller.upcomingEvents),
              _buildEventList(controller.pastEvents),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEventList(List<EventModel> events) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          'No events found',
          style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
      itemBuilder: (context, index) {
        final event = events[index];
        return InkWell(
          onTap: () => Get.toNamed(AppRoutes.eventDetail.replaceFirst(':id', event.id)),
          borderRadius: BorderRadius.circular(16),
          child: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (event.imageUrl != null)
                FVImage(
                  imageUrl: event.imageUrl!,
                  height: 180,
                  borderRadius: 16,
                ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM dd, yyyy • h:mm a').format(event.eventDate),
                          style: AppTypography.labelLarge.copyWith(color: AppColors.accent),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            event.category,
                            style: AppTypography.caption,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.title,
                      style: AppTypography.headingSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        FVIcon(PhosphorIconsRegular.mapPin, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${event.venue}, ${event.city}',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          event.fandomName ?? '',
                          style: AppTypography.caption.copyWith(color: AppColors.primaryLight),
                        ),
                        const Spacer(),
                        if (event.attendeeCount != null) ...[
                          FVIcon(PhosphorIconsRegular.users, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${event.attendeeCount} attending',
                            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ],
                    )
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
